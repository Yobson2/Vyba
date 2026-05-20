import 'package:drift/drift.dart';
import 'package:flutter_templates/core/database/app_database.dart';
import 'package:flutter_templates/core/database/tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

/// DAO for sync queue CRUD operations.
@DriftAccessor(tables: [SyncQueueEntries])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  /// Creates a [SyncQueueDao].
  SyncQueueDao(super.db);

  /// Inserts a new pending sync operation.
  Future<int> enqueue({
    required String entityType,
    required String entityId,
    required String operation,
    String? payload,
  }) {
    return into(syncQueueEntries).insert(
      SyncQueueEntriesCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        payload: Value(payload),
      ),
    );
  }

  /// Gets all pending entries in FIFO order.
  Future<List<SyncQueueEntry>> getPending() {
    return (select(syncQueueEntries)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Watches the count of pending entries (for UI badges).
  Stream<int> watchPendingCount() {
    final countExpr = syncQueueEntries.id.count();
    final query = selectOnly(syncQueueEntries)
      ..addColumns([countExpr])
      ..where(syncQueueEntries.status.equals('pending'));
    return query.map((row) => row.read(countExpr)!).watchSingle();
  }

  /// Marks an entry as in_progress.
  Future<void> markInProgress(int id) {
    return (update(syncQueueEntries)..where((t) => t.id.equals(id))).write(
      const SyncQueueEntriesCompanion(
        status: Value('in_progress'),
      ),
    );
  }

  /// Removes a successfully synced entry.
  Future<void> markCompleted(int id) {
    return (delete(syncQueueEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Marks an entry as failed with error details and resets to pending.
  Future<void> markFailed(int id, String error) {
    return (update(syncQueueEntries)..where((t) => t.id.equals(id))).write(
      SyncQueueEntriesCompanion(
        status: const Value('pending'),
        lastError: Value(error),
      ),
    );
  }

  /// Increments the retry count for a given entry.
  Future<void> incrementRetryCount(int id) async {
    final entry = await (select(syncQueueEntries)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    await (update(syncQueueEntries)..where((t) => t.id.equals(id))).write(
      SyncQueueEntriesCompanion(
        retryCount: Value(entry.retryCount + 1),
      ),
    );
  }

  /// Removes all entries for a specific entity.
  Future<void> removeForEntity(String entityType, String entityId) {
    return (delete(syncQueueEntries)
          ..where(
            (t) =>
                t.entityType.equals(entityType) & t.entityId.equals(entityId),
          ))
        .go();
  }

  /// Clears the entire queue (e.g., on logout).
  Future<void> clearAll() => delete(syncQueueEntries).go();
}
