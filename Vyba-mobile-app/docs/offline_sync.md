# Offline-First Data Synchronization with Drift

> **Superseded.** The validation build removed the Drift offline-sync queue and
> the `notes` demo feature it was built around (ticket 02, `docs/validation-mvp/`).
> The app now keeps only a plain read cache for the feed and venue list — there is
> no write-queue, sync engine, or conflict resolution in the shipped code. This
> document is kept for historical reference only; do not use it as a guide to the
> current architecture.

This document explains the complete offline-first sync architecture, how data flows through each layer, and how to add sync support to your own features.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [How Drift Works](#how-drift-works)
3. [Database Setup](#database-setup)
4. [The Sync Queue](#the-sync-queue)
5. [The Sync Engine](#the-sync-engine)
6. [Complete Data Flow: Creating a Note](#complete-data-flow-creating-a-note)
7. [Complete Data Flow: Reading Notes](#complete-data-flow-reading-notes)
8. [Complete Data Flow: Connectivity Returns](#complete-data-flow-connectivity-returns)
9. [Conflict Resolution](#conflict-resolution)
10. [Retry & Backoff Strategy](#retry--backoff-strategy)
11. [UI Integration](#ui-integration)
12. [File Map](#file-map)
13. [Adding a New Syncable Feature](#adding-a-new-syncable-feature)
14. [Environment Configuration](#environment-configuration)

---

## Architecture Overview

### Before (Online-Only)

```
User taps "Create"
    -> Notifier
    -> UseCase
    -> Repository
    -> RemoteDataSource (Dio HTTP call)
    -> Wait for server response...
    -> Return result to UI

Problem: If offline, the call fails. User sees an error.
```

### After (Offline-First)

```
User taps "Create"
    -> Notifier
    -> UseCase
    -> Repository
    -> LocalDatabase (Drift/SQLite) ← saves IMMEDIATELY, returns success
    -> SyncQueue (Drift table)      ← enqueues operation for later
    -> UI updates instantly

Meanwhile, in the background:
    SyncEngine listens to connectivity
    -> Connectivity restored?
    -> Read pending entries from SyncQueue
    -> For each entry, call the server via SyncHandler
    -> On success: remove from queue, mark note as synced
    -> On failure: retry with exponential backoff
    -> UI auto-updates via Drift's reactive streams
```

### Key Principles

| Principle | What it means |
|-----------|---------------|
| **Write-local-first** | All mutations (create/update/delete) save to SQLite immediately and return success |
| **Read-local-always** | UI always reads from the local database, never directly from the server |
| **Background sync** | A queue of pending operations is replayed when connectivity is available |
| **Client-generated UUIDs** | IDs are created locally (UUID v4), so no server round-trip needed to get an ID |
| **Feature opt-in** | Only features that need sync implement a `SyncHandler`. Auth stays on SharedPreferences |

---

## How Drift Works

[Drift](https://drift.simonbinder.eu/) is a type-safe SQLite wrapper for Dart/Flutter. It uses code generation (`build_runner`) to create type-safe queries, data classes, and reactive streams.

### Core Concepts

```
Table Definition (you write)     Code Generation (build_runner)     Runtime
─────────────────────────────    ─────────────────────────────────   ──────────────
class Notes extends Table {      -> Note (data class)                -> SQLite DB
  TextColumn get id => ...       -> NotesCompanion (for inserts)     -> Reactive streams
  TextColumn get title => ...    -> $NotesTable (query helpers)      -> Type-safe queries
}                                -> _$AppDatabase (mixin)
```

**Table** = You define columns in a Dart class extending `Table`. Drift generates:
- A **data class** (`Note`) with all fields — used to read rows
- A **companion class** (`NotesCompanion`) — used to insert/update rows (allows partial updates via `Value.absent()`)
- Query builders that catch SQL errors at compile time

**DAO** (Data Access Object) = A class with methods for specific queries (`watchAll`, `getById`, `upsert`, etc.). Each DAO is scoped to specific tables.

**Database** = The central class (`AppDatabase`) that aggregates all tables and DAOs. It manages the SQLite connection and migrations.

### Generated vs Hand-Written

| You write | Drift generates |
|-----------|-----------------|
| `lib/core/database/tables/sync_queue_table.dart` | Included in `app_database.g.dart` |
| `lib/features/notes/data/tables/notes_table.dart` | Included in `app_database.g.dart` |
| `lib/core/database/daos/sync_queue_dao.dart` | `sync_queue_dao.g.dart` (mixin) |
| `lib/features/notes/data/daos/notes_dao.dart` | `notes_dao.g.dart` (mixin) |
| `lib/core/database/app_database.dart` | `app_database.g.dart` (the big one) |

Regenerate with: `dart run build_runner build --delete-conflicting-outputs`

---

## Database Setup

### Tables

**Notes Table** (`lib/features/notes/data/tables/notes_table.dart`):

```dart
class Notes extends Table {
  TextColumn get id => text()();           // Client-generated UUID (primary key)
  TextColumn get serverId => text().nullable()();  // Server-assigned ID (null until synced)
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};      // UUID as primary key, NOT auto-increment
}
```

Key design decisions:
- `id` is a UUID string, not an auto-increment integer. This allows creating records offline without needing a server to assign an ID.
- `serverId` is nullable — it's `null` until the first successful sync to the server.
- `isSynced` tracks whether the local version matches the server version.

**Sync Queue Table** (`lib/core/database/tables/sync_queue_table.dart`):

```dart
class SyncQueueEntries extends Table {
  IntColumn get id => integer().autoIncrement()();   // FIFO ordering
  TextColumn get entityType => text()();              // e.g., 'note'
  TextColumn get entityId => text()();                // The UUID of the entity
  TextColumn get operation => text()();               // 'create', 'update', or 'delete'
  TextColumn get payload => text().nullable()();      // JSON snapshot of the entity at mutation time
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get lastError => text().nullable()();
}
```

The sync queue uses auto-increment `id` for strict FIFO ordering. Each row represents one mutation that needs to reach the server.

### AppDatabase

```dart
@DriftDatabase(
  tables: [SyncQueueEntries, Notes],   // All tables registered here
  daos: [SyncQueueDao, NotesDao],      // All DAOs registered here
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;          // Increment when you change table structure

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),    // First install: create all tables
    onUpgrade: (m, from, to) async {}, // Future schema migrations go here
  );
}
```

### Database Provider

```dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase(_openConnection());
  ref.onDispose(db.close);
  return db;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'flutter_templates.db'));
    return NativeDatabase.createInBackground(file);   // SQLite runs on isolate
  });
}
```

- `keepAlive: true` ensures one database instance for the app's lifetime
- `LazyDatabase` defers opening until the first query
- `createInBackground` runs SQLite on a separate isolate for performance

---

## The Sync Queue

The sync queue is the bridge between "save locally" and "push to server". Every mutation enqueues an entry.

### Queue Entry Lifecycle

```
                    ┌──────────────────────────┐
                    │       User mutates        │
                    │  (create/update/delete)    │
                    └─────────────┬────────────┘
                                  │
                                  ▼
                    ┌──────────────────────────┐
                    │  Status: 'pending'        │
                    │  retryCount: 0            │
                    │  payload: JSON snapshot   │
                    └─────────────┬────────────┘
                                  │
                    SyncEngine picks it up
                                  │
                                  ▼
                    ┌──────────────────────────┐
                    │  Status: 'in_progress'    │
                    └─────────────┬────────────┘
                                  │
                          ┌───────┴───────┐
                          │               │
                     Success           Failure
                          │               │
                          ▼               ▼
                    ┌────────────┐  ┌──────────────────┐
                    │  DELETED   │  │ Status: 'pending' │
                    │ from queue │  │ retryCount + 1    │
                    └────────────┘  │ lastError: '...'  │
                                   └──────────────────┘
                                          │
                                    retryCount >= 5?
                                          │
                                     ┌────┴────┐
                                     │         │
                                    No        Yes
                                     │         │
                                     ▼         ▼
                               Retry next   Skipped
                               sync cycle   (logged)
```

### SyncQueueDao Methods

| Method | What it does |
|--------|-------------|
| `enqueue(...)` | Inserts a new entry with status `'pending'` |
| `getPending()` | Returns all pending entries in FIFO order (oldest first) |
| `watchPendingCount()` | Reactive stream of pending count (for UI badges) |
| `markInProgress(id)` | Sets status to `'in_progress'` |
| `markCompleted(id)` | **Deletes** the entry from the queue (sync succeeded) |
| `markFailed(id, error)` | Resets status to `'pending'` with error message |
| `incrementRetryCount(id)` | Bumps `retryCount` by 1 |
| `removeForEntity(type, id)` | Removes all queue entries for a specific entity |
| `clearAll()` | Wipes the queue (e.g., on logout) |

---

## The Sync Engine

The `SyncEngine` is the central orchestrator. It runs as a singleton (`keepAlive: true` provider) for the app's lifetime.

### How It Starts

```dart
@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final engine = SyncEngine(
    syncQueueDao: db.syncQueueDao,
    networkInfo: networkInfo,
  );

  // Listen to connectivity changes
  engine.start(
    connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    ),
  );

  return engine;
}
```

The engine receives a `Stream<bool>` (online/offline). When it sees `true`, it calls `processQueue()`.

### SyncHandler Interface

Each syncable feature implements this contract:

```dart
abstract class SyncHandler {
  String get entityType;                                    // e.g., 'note'
  Future<String> pushCreate(String entityId, String payload);  // -> server ID
  Future<void> pushUpdate(String entityId, String payload);
  Future<void> pushDelete(String entityId);
  Future<String?> fetchRemote(String entityId);             // For conflict resolution
  Future<void> applyServerVersion(String entityId, String serverPayload);
}
```

Features register their handler during provider initialization:

```dart
// In notes_providers.dart
@riverpod
NotesSyncHandler notesSyncHandler(Ref ref) {
  final handler = NotesSyncHandler(...);
  ref.watch(syncEngineProvider).registerHandler(handler);  // Registration!
  return handler;
}
```

### SyncStatus Stream

The engine emits a `SyncStatus` stream for UI consumption:

```dart
sealed class SyncStatus {
  SyncStatus.idle()                           // Nothing to do
  SyncStatus.syncing(total, completed)        // Processing queue
  SyncStatus.synced()                         // All done
  SyncStatus.error(message)                   // Something failed
  SyncStatus.offline(pendingCount)            // No connectivity
}
```

---

## Complete Data Flow: Creating a Note

Here's every step that happens when the user taps "Create":

```
Step 1: UI Layer
─────────────────────────────────────────────────────────────────────
NoteDetailPage._saveNote()
  -> ref.read(notesNotifierProvider.notifier).createNote(title, content)

Step 2: Notifier
─────────────────────────────────────────────────────────────────────
NotesNotifier.createNote()
  state = NotesState.loading()
  -> ref.read(createNoteUseCaseProvider).call(CreateNoteParams(...))

Step 3: Use Case
─────────────────────────────────────────────────────────────────────
CreateNoteUseCase.call(params)
  -> _repository.createNote(title: params.title, content: params.content)

Step 4: Repository (THIS IS WHERE OFFLINE-FIRST HAPPENS)
─────────────────────────────────────────────────────────────────────
NotesRepositoryImpl.createNote()
  1. Generate UUID:     localId = Uuid().v4()
  2. Create model:      NoteModel(id: localId, isSynced: false, ...)
  3. Save locally:      _local.saveNote(model, isSynced: false)
  4. Enqueue sync:      _local.enqueueSync(entityId: localId,
                           operation: 'create',
                           payload: json.encode(model.toJson()))
  5. Return success:    Right(model.toEntity())

  NOTE: No network call! This returns instantly whether online or offline.

Step 5: Local Data Source
─────────────────────────────────────────────────────────────────────
NotesLocalDataSourceImpl.saveNote(model)
  -> _notesDao.upsert(model.toDriftCompanion(isSynced: false))
     -> INSERT OR REPLACE INTO notes (id, title, content, ..., is_synced=false)

NotesLocalDataSourceImpl.enqueueSync(...)
  -> _syncQueueDao.enqueue(entityType: 'note', entityId: localId,
                            operation: 'create', payload: '{"id":"...","title":"..."}')
     -> INSERT INTO sync_queue_entries (entity_type, entity_id, operation, payload, status='pending')

Step 6: Back to UI
─────────────────────────────────────────────────────────────────────
NotesNotifier receives Right(note)
  state = NotesState.success(message: 'Note created')

NoteDetailPage.ref.listen detects NotesSuccess
  -> context.pop() (navigates back to notes list)

Step 7: Notes List Auto-Updates
─────────────────────────────────────────────────────────────────────
NotesPage watches notesStreamProvider
  -> notesStreamProvider watches notesRepository.watchNotes()
  -> watchNotes() calls _local.watchNotes()
  -> Drift's watchAll() emits a new list because the notes table changed
  -> UI rebuilds with the new note in the list
  -> Note shows cloud_upload icon because isSynced == false
```

---

## Complete Data Flow: Reading Notes

```
NotesPage.build()
  -> ref.watch(notesStreamProvider)

notesStreamProvider
  -> notesRepository.watchNotes()

NotesRepositoryImpl.watchNotes()
  -> _local.watchNotes()

NotesLocalDataSourceImpl.watchNotes()
  -> _notesDao.watchAll()
  -> Drift returns Stream<List<Note>> from SQLite
  -> Maps each row to NoteModel.fromDrift(row)

Stream flows back up:
  -> Repository maps NoteModel -> Note entity
  -> notesStreamProvider emits AsyncData<List<Note>>
  -> NotesPage.notesAsync.when(data: (notes) => _NotesList(notes))

Key: The UI NEVER calls the server directly for reads.
Server data enters the local DB via background refresh or sync,
and Drift's reactive stream automatically pushes updates to the UI.
```

---

## Complete Data Flow: Connectivity Returns

```
Step 1: Connectivity Plugin Detects Network
─────────────────────────────────────────────────────────────────────
connectivity_plus fires onConnectivityChanged([ConnectivityResult.wifi])
  -> Mapped to Stream<bool>: true (not none)

Step 2: SyncEngine Receives Event
─────────────────────────────────────────────────────────────────────
SyncEngine.start() listener fires with isOnline=true
  -> Calls processQueue()

Step 3: Process Queue
─────────────────────────────────────────────────────────────────────
processQueue():
  1. Check: _isSyncing? No -> proceed
  2. Check: _networkInfo.isConnected? Yes -> proceed
  3. Get pending entries: _syncQueueDao.getPending()
     -> Returns [SyncQueueEntry(entityType: 'note', operation: 'create', ...)]
  4. Emit: SyncStatus.syncing(total: 1, completed: 0)

Step 4: Process Each Entry
─────────────────────────────────────────────────────────────────────
_processEntry(entry, handler):
  1. Mark in_progress: _syncQueueDao.markInProgress(entry.id)
  2. Switch on entry.operation:
     case 'create':
       -> handler.pushCreate(entry.entityId, entry.payload)

Step 5: SyncHandler Pushes to Server
─────────────────────────────────────────────────────────────────────
NotesSyncHandler.pushCreate(entityId, payload):
  1. Deserialize: model = NoteModel.fromJson(json.decode(payload))
  2. Call server:  serverModel = await _remote.createNote(model)
     -> POST /notes with JSON body
     -> Server returns model with serverId assigned
  3. Mark synced:  _local.markSynced(entityId, serverId: serverModel.serverId)
     -> UPDATE notes SET is_synced=true, server_id='server_xxx' WHERE id='uuid'
  4. Return:       serverModel.serverId

Step 6: Queue Entry Completed
─────────────────────────────────────────────────────────────────────
Back in _processEntry():
  -> _syncQueueDao.markCompleted(entry.id)
     -> DELETE FROM sync_queue_entries WHERE id = entry.id

Step 7: UI Auto-Updates
─────────────────────────────────────────────────────────────────────
Drift detects the notes table changed (is_synced flipped to true)
  -> watchAll() emits a new list
  -> NoteModel.fromDrift reads isSynced = true
  -> UI rebuilds: cloud_upload icon disappears
  -> SyncStatusBanner shows "Synced" briefly, then hides

Step 8: Pending Count Updates
─────────────────────────────────────────────────────────────────────
SyncQueueDao.watchPendingCount() detects queue is empty
  -> Emits 0
  -> _SyncBadge hides (count == 0)
```

---

## Conflict Resolution

When the server returns HTTP 409 (Conflict), the engine uses a **server-wins** strategy:

```
Server returns 409
    │
    ▼
_resolveConflict(entry, handler)
    │
    ├─ 1. handler.fetchRemote(entityId)
    │     -> GET /notes/{id} from server
    │     -> Returns JSON string of server version
    │
    ├─ 2. handler.applyServerVersion(entityId, serverPayload)
    │     -> Deserializes the server JSON
    │     -> _local.saveNote(serverModel, isSynced: true)
    │     -> Overwrites local version with server version
    │
    └─ 3. _syncQueueDao.markCompleted(entry.id)
          -> Removes the conflicting queue entry
          -> Drift stream fires -> UI shows server version
```

**Upgrading to last-write-wins**: In `applyServerVersion`, compare `updatedAt` timestamps between local and server versions. Keep the one with the later timestamp.

---

## Retry & Backoff Strategy

Configuration (`SyncConfig`):

| Setting | Default | Purpose |
|---------|---------|---------|
| `maxRetries` | 5 | Max attempts before giving up |
| `initialBackoffMs` | 1000 | First retry delay (1 second) |
| `maxBackoffMs` | 60000 | Maximum delay cap (60 seconds) |
| `backoffMultiplier` | 2.0 | Exponential multiplier |
| `batchSize` | 10 | Entries per sync cycle |

Backoff schedule: `1s -> 2s -> 4s -> 8s -> 16s` (capped at 60s)

```
Attempt 1: immediate
  Failed -> retryCount = 1, wait 1s

Attempt 2: after 1s
  Failed -> retryCount = 2, wait 2s

Attempt 3: after 2s
  Failed -> retryCount = 3, wait 4s

Attempt 4: after 4s
  Failed -> retryCount = 4, wait 8s

Attempt 5: after 8s
  Failed -> retryCount = 5, SKIPPED on next cycle
  SyncStatus.error('Sync failed for note/uuid after 5 retries')
```

---

## UI Integration

### SyncStatusBanner

Place below the app bar to show sync state:

```dart
Scaffold(
  body: Column(
    children: [
      const SyncStatusBanner(),  // Shows offline/syncing/error banners
      Expanded(child: yourContent),
    ],
  ),
)
```

| State | Banner |
|-------|--------|
| `SyncIdle` | Hidden |
| `SyncSyncing(3, 1)` | Blue: "Syncing... (1/3)" |
| `SyncSynced` | Hidden |
| `SyncError(msg)` | Red: "Sync failed: msg" + Retry button |
| `SyncOffline(2)` | Red: "Offline. 2 changes pending." |

### Pending Sync Badge

Shows count of pending operations on an icon:

```dart
ref.watch(pendingSyncCountProvider).when(
  data: (count) => Badge(
    label: Text('$count'),
    child: IconButton(
      icon: Icon(Icons.cloud_upload_outlined),
      onPressed: () => ref.read(syncEngineProvider).processQueue(),
    ),
  ),
)
```

### Per-Item Sync Icon

Show unsynced state on individual items:

```dart
trailing: note.isSynced
    ? null
    : Icon(Icons.cloud_upload_outlined, size: 18)
```

---

## File Map

### Core Sync Infrastructure

```
lib/core/
├── database/
│   ├── app_database.dart              # Central Drift DB (aggregates tables + DAOs)
│   ├── app_database.g.dart            # Generated (DO NOT EDIT)
│   ├── database_providers.dart        # Riverpod provider for AppDatabase singleton
│   ├── database_providers.g.dart      # Generated
│   ├── tables/
│   │   └── sync_queue_table.dart      # Sync queue table definition
│   └── daos/
│       ├── sync_queue_dao.dart        # Sync queue CRUD operations
│       └── sync_queue_dao.g.dart      # Generated
├── sync/
│   ├── sync_engine.dart               # SyncHandler interface + SyncEngine orchestrator
│   ├── sync_status.dart               # Freezed sealed class for sync state
│   ├── sync_status.freezed.dart       # Generated
│   ├── sync_config.dart               # Retry config (backoff, max retries)
│   └── sync_providers.dart            # syncEngine, syncStatus, pendingSyncCount
├── error/
│   ├── exceptions.dart                # + SyncException
│   └── failures.dart                  # + SyncFailure
└── widgets/feedback/
    ├── sync_status_banner.dart        # Full-width banner for sync state
    └── sync_status_icon.dart          # Small icon for per-item sync state
```

### Notes Feature (Reference Implementation)

```
lib/features/notes/
├── domain/
│   ├── entities/
│   │   └── note.dart                  # Note entity with isSynced flag
│   ├── repositories/
│   │   └── notes_repository.dart      # Abstract contract (watchNotes, CRUD, refresh)
│   └── usecases/
│       ├── create_note_usecase.dart
│       ├── update_note_usecase.dart
│       ├── delete_note_usecase.dart
│       └── get_notes_usecase.dart
├── data/
│   ├── tables/
│   │   └── notes_table.dart           # Drift table (id, serverId, title, content, isSynced)
│   ├── daos/
│   │   ├── notes_dao.dart             # watchAll, upsert, deleteById, markSynced, replaceAll
│   │   └── notes_dao.g.dart           # Generated
│   ├── models/
│   │   ├── note_model.dart            # Freezed model (fromJson, fromDrift, toEntity, toDriftCompanion)
│   │   ├── note_model.freezed.dart    # Generated
│   │   └── note_model.g.dart          # Generated
│   ├── datasources/
│   │   ├── notes_remote_datasource.dart   # Dio impl + Mock impl
│   │   ├── notes_local_datasource.dart    # Drift impl with sync queue enqueuing
│   │   └── notes_sync_handler.dart        # Implements SyncHandler for notes
│   └── repositories/
│       └── notes_repository_impl.dart     # Offline-first: write-local, enqueue sync
└── presentation/
    ├── providers/
    │   ├── notes_providers.dart        # DI wiring (data sources, repository, use cases)
    │   ├── notes_providers.g.dart      # Generated
    │   ├── notes_notifier.dart         # State management (create/update/delete actions)
    │   ├── notes_notifier.g.dart       # Generated
    │   ├── notes_state.dart            # Freezed sealed: initial, loading, success, error
    │   └── notes_state.freezed.dart    # Generated
    └── pages/
        ├── notes_page.dart             # List page with sync banner + badge
        └── note_detail_page.dart       # Create/edit form
```

---

## Adding a New Syncable Feature

Follow these steps to add offline-first sync to a new feature (e.g., "Tasks"):

### 1. Define the Table

```dart
// lib/features/tasks/data/tables/tasks_table.dart
import 'package:drift/drift.dart';

class Tasks extends Table {
  TextColumn get id => text()();              // Client UUID
  TextColumn get serverId => text().nullable()();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 2. Create the DAO

```dart
// lib/features/tasks/data/daos/tasks_dao.dart
import 'package:drift/drift.dart';
import 'package:flutter_templates/core/database/app_database.dart';
import 'package:flutter_templates/features/tasks/data/tables/tasks_table.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Stream<List<Task>> watchAll() { /* ... */ }
  Future<void> upsert(TasksCompanion entry) { /* ... */ }
  Future<void> deleteById(String id) { /* ... */ }
  Future<void> markSynced(String id, {String? serverId}) { /* ... */ }
  Future<void> replaceAll(List<TasksCompanion> items) { /* ... */ }
}
```

### 3. Register in AppDatabase

```dart
// lib/core/database/app_database.dart
@DriftDatabase(
  tables: [SyncQueueEntries, Notes, Tasks],       // <- Add Tasks
  daos: [SyncQueueDao, NotesDao, TasksDao],       // <- Add TasksDao
)
class AppDatabase extends _$AppDatabase {
  // Increment schemaVersion if modifying existing tables
  @override
  int get schemaVersion => 2;  // was 1

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(tasks);  // Add migration for new table
      }
    },
  );
}
```

### 4. Create the Model

```dart
// lib/features/tasks/data/models/task_model.dart
@freezed
abstract class TaskModel with _$TaskModel {
  const TaskModel._();
  const factory TaskModel({/* fields */}) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  factory TaskModel.fromDrift(db.Task row) => /* ... */;
  Note toEntity() => /* ... */;
  db.TasksCompanion toDriftCompanion({required bool isSynced}) => /* ... */;
}
```

### 5. Implement the SyncHandler

```dart
// lib/features/tasks/data/datasources/tasks_sync_handler.dart
class TasksSyncHandler implements SyncHandler {
  @override
  String get entityType => 'task';  // Must be unique across all features

  @override
  Future<String> pushCreate(String entityId, String payload) async {
    final model = TaskModel.fromJson(json.decode(payload));
    final serverModel = await _remote.createTask(model);
    await _local.markSynced(entityId, serverId: serverModel.serverId);
    return serverModel.serverId ?? entityId;
  }

  // ... pushUpdate, pushDelete, fetchRemote, applyServerVersion
}
```

### 6. Wire Up Providers

```dart
// lib/features/tasks/presentation/providers/tasks_providers.dart
@riverpod
TasksSyncHandler tasksSyncHandler(Ref ref) {
  final handler = TasksSyncHandler(/* ... */);
  ref.watch(syncEngineProvider).registerHandler(handler);  // IMPORTANT!
  return handler;
}

@riverpod
TasksRepository tasksRepository(Ref ref) {
  ref.watch(tasksSyncHandlerProvider);  // Ensures handler is registered
  return TasksRepositoryImpl(/* ... */);
}
```

### 7. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Checklist

- [ ] Table extends `Table` with `id` as text UUID primary key
- [ ] Table has `serverId` (nullable) and `isSynced` (boolean, default false) columns
- [ ] DAO registered in `AppDatabase`
- [ ] Model has `fromDrift`, `toEntity`, `toDriftCompanion` converters
- [ ] SyncHandler has unique `entityType` string
- [ ] Handler registered with `syncEngineProvider` in provider
- [ ] Repository calls `ref.watch(syncHandlerProvider)` to ensure registration
- [ ] Repository uses write-local-first + enqueue pattern
- [ ] Repository uses `watchNotes()` pattern for reactive reads
- [ ] `schemaVersion` incremented if adding to existing database

---

## Environment Configuration

| Variable | Values | Purpose |
|----------|--------|---------|
| `USE_MOCK_NOTES` | `true` / `false` | Use in-memory mock instead of real API |
| `USE_MOCK_AUTH` | `true` / `false` | Use mock auth (already existed) |

Set in `.env`:
```
USE_MOCK_NOTES=true
```

The mock remote data source (`MockNotesRemoteDataSourceImpl`) simulates server behavior with 800ms delays and an in-memory list. It supports the full CRUD contract, making it suitable for testing the complete offline-first flow without a backend.
