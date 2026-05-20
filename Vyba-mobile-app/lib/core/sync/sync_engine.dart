import 'dart:async';

import 'package:flutter_templates/core/database/app_database.dart';
import 'package:flutter_templates/core/database/daos/sync_queue_dao.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/core/sync/sync_config.dart';
import 'package:flutter_templates/core/sync/sync_status.dart';
import 'package:flutter_templates/core/utils/logger.dart';

/// Contract that each syncable feature must implement.
///
/// Registered with the [SyncEngine] so it knows how to
/// push each entity type's operations to the server.
abstract class SyncHandler {
  /// The entity type string this handler manages (e.g., 'note').
  String get entityType;

  /// Pushes a create operation to the server.
  /// Returns the server-assigned ID (may differ from local ID).
  Future<String> pushCreate(String entityId, String payload);

  /// Pushes an update operation to the server.
  Future<void> pushUpdate(String entityId, String payload);

  /// Pushes a delete operation to the server.
  Future<void> pushDelete(String entityId);

  /// Fetches the latest version from the server for conflict resolution.
  /// Returns null if the entity doesn't exist on the server.
  Future<String?> fetchRemote(String entityId);

  /// Applies the server version locally (for server-wins conflict resolution).
  Future<void> applyServerVersion(String entityId, String serverPayload);
}

/// Orchestrates background synchronization of offline mutations.
class SyncEngine {
  /// Creates a [SyncEngine].
  SyncEngine({
    required SyncQueueDao syncQueueDao,
    required NetworkInfo networkInfo,
    SyncConfig config = const SyncConfig(),
  })  : _syncQueueDao = syncQueueDao,
        _networkInfo = networkInfo,
        _config = config;

  final SyncQueueDao _syncQueueDao;
  final NetworkInfo _networkInfo;
  final SyncConfig _config;

  final Map<String, SyncHandler> _handlers = {};
  final _statusController = StreamController<SyncStatus>.broadcast();

  bool _isSyncing = false;
  StreamSubscription<bool>? _connectivitySubscription;

  /// Stream of sync status updates for UI consumption.
  Stream<SyncStatus> get statusStream => _statusController.stream;

  /// Registers a [SyncHandler] for a specific entity type.
  void registerHandler(SyncHandler handler) {
    _handlers[handler.entityType] = handler;
  }

  /// Starts listening to connectivity changes.
  ///
  /// Call this once during app initialization.
  void start(Stream<bool> connectivityStream) {
    _connectivitySubscription = connectivityStream.listen((isOnline) {
      if (isOnline) {
        processQueue();
      } else {
        _emitOfflineStatus();
      }
    });
  }

  /// Stops listening and cleans up resources.
  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _statusController.close();
  }

  /// Triggers a sync cycle. Called automatically when connectivity
  /// returns, or can be called manually (e.g., pull-to-refresh).
  Future<void> processQueue() async {
    if (_isSyncing) return;
    if (!await _networkInfo.isConnected) {
      await _emitOfflineStatus();
      return;
    }

    _isSyncing = true;

    try {
      final pending = await _syncQueueDao.getPending();
      if (pending.isEmpty) {
        _statusController.add(const SyncStatus.idle());
        return;
      }

      _statusController.add(SyncStatus.syncing(
        total: pending.length,
        completed: 0,
      ));

      var completed = 0;
      for (final entry in pending) {
        if (!await _networkInfo.isConnected) {
          await _emitOfflineStatus();
          return;
        }

        final handler = _handlers[entry.entityType];
        if (handler == null) {
          AppLogger.warning(
            'No SyncHandler registered for "${entry.entityType}"',
            tag: 'SyncEngine',
          );
          continue;
        }

        if (entry.retryCount >= _config.maxRetries) {
          AppLogger.error(
            'Max retries exceeded for queue entry ${entry.id}',
            tag: 'SyncEngine',
          );
          continue;
        }

        await _processEntry(entry, handler);
        completed++;
        _statusController.add(SyncStatus.syncing(
          total: pending.length,
          completed: completed,
        ));
      }

      _statusController.add(const SyncStatus.synced());
    } catch (e) {
      _statusController.add(SyncStatus.error(e.toString()));
      AppLogger.error('Sync cycle failed', tag: 'SyncEngine', error: e);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processEntry(
    SyncQueueEntry entry,
    SyncHandler handler,
  ) async {
    await _syncQueueDao.markInProgress(entry.id);

    try {
      switch (entry.operation) {
        case 'create':
          await handler.pushCreate(entry.entityId, entry.payload!);
          await _syncQueueDao.markCompleted(entry.id);

        case 'update':
          await handler.pushUpdate(entry.entityId, entry.payload!);
          await _syncQueueDao.markCompleted(entry.id);

        case 'delete':
          await handler.pushDelete(entry.entityId);
          await _syncQueueDao.markCompleted(entry.id);
      }
    } on ServerException catch (e) {
      if (e.statusCode == 409) {
        await _resolveConflict(entry, handler);
      } else {
        await _handleRetry(entry, e.message);
      }
    } on NetworkException {
      await _syncQueueDao.markFailed(entry.id, 'Network lost during sync');
    } catch (e) {
      await _handleRetry(entry, e.toString());
    }
  }

  /// Server-wins conflict resolution.
  Future<void> _resolveConflict(
    SyncQueueEntry entry,
    SyncHandler handler,
  ) async {
    AppLogger.info(
      'Conflict detected for ${entry.entityType}/${entry.entityId}, '
      'applying server-wins',
      tag: 'SyncEngine',
    );

    try {
      final serverPayload = await handler.fetchRemote(entry.entityId);
      if (serverPayload != null) {
        await handler.applyServerVersion(entry.entityId, serverPayload);
      }
      await _syncQueueDao.markCompleted(entry.id);
    } catch (e) {
      await _handleRetry(entry, 'Conflict resolution failed: $e');
    }
  }

  Future<void> _handleRetry(SyncQueueEntry entry, String error) async {
    if (entry.retryCount + 1 >= _config.maxRetries) {
      _statusController.add(SyncStatus.error(
        'Sync failed for ${entry.entityType}/${entry.entityId} after '
        '${_config.maxRetries} retries',
      ));
    }
    await _syncQueueDao.markFailed(entry.id, error);
    await _syncQueueDao.incrementRetryCount(entry.id);

    final backoff = _config.backoffFor(entry.retryCount);
    await Future<void>.delayed(backoff);
  }

  Future<void> _emitOfflineStatus() async {
    final pending = await _syncQueueDao.getPending();
    _statusController.add(SyncStatus.offline(pendingCount: pending.length));
  }
}
