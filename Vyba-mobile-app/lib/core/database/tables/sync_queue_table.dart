import 'package:drift/drift.dart';

/// Represents a pending sync operation in the queue.
///
/// Each row is one mutation (create/update/delete) that needs
/// to be sent to the server when connectivity is available.
class SyncQueueEntries extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// The entity type this operation applies to (e.g., 'note').
  TextColumn get entityType => text()();

  /// The local ID of the entity being synced.
  TextColumn get entityId => text()();

  /// The operation type: 'create', 'update', or 'delete'.
  TextColumn get operation => text()();

  /// JSON-serialized payload of the entity data at time of mutation.
  /// Null for delete operations.
  TextColumn get payload => text().nullable()();

  /// When this queue entry was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Number of retry attempts so far.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// Status: 'pending', 'in_progress', 'failed'.
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// Optional error message from the last failed attempt.
  TextColumn get lastError => text().nullable()();
}
