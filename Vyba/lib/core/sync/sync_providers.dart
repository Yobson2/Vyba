import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/database/database_providers.dart';
import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/core/sync/sync_engine.dart';
import 'package:flutter_templates/core/sync/sync_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_providers.g.dart';

/// Provides the [SyncEngine] singleton.
///
/// Features register their [SyncHandler] implementations
/// during provider initialization.
@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final engine = SyncEngine(
    syncQueueDao: db.syncQueueDao,
    networkInfo: networkInfo,
  );

  // Start engine with the raw connectivity stream.
  final connectivity = ref.watch(connectivityProvider);
  engine.start(
    connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    ),
  );

  ref.onDispose(engine.dispose);
  return engine;
}

/// Streams the current [SyncStatus] for UI widgets.
@riverpod
Stream<SyncStatus> syncStatus(Ref ref) {
  final engine = ref.watch(syncEngineProvider);
  return engine.statusStream;
}

/// Provides the count of pending sync operations for badges.
@riverpod
Stream<int> pendingSyncCount(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.syncQueueDao.watchPendingCount();
}
