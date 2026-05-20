import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_status.freezed.dart';

/// Represents the current state of the sync engine.
@freezed
sealed class SyncStatus with _$SyncStatus {
  /// No pending operations, everything is synced.
  const factory SyncStatus.idle() = SyncIdle;

  /// Currently syncing operations.
  const factory SyncStatus.syncing({
    required int total,
    required int completed,
  }) = SyncSyncing;

  /// All operations synced successfully.
  const factory SyncStatus.synced() = SyncSynced;

  /// Sync encountered an error.
  const factory SyncStatus.error(String message) = SyncError;

  /// Device is offline, operations are queued.
  const factory SyncStatus.offline({required int pendingCount}) = SyncOffline;
}
