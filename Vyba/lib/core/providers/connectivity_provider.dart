import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Streams connectivity changes as a boolean (online/offline).
///
/// Used by the [AppOfflineBanner] and repository implementations
/// to react to network state transitions.
///

@riverpod
Stream<bool> connectivityStatus(Ref ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.onConnectivityChanged.map(
    (results) => !results.contains(ConnectivityResult.none),
  );
}

/// Synchronous snapshot of whether the device is currently online.
///
/// Returns `true` by default until the first connectivity event.
@riverpod
bool isOnline(Ref ref) {
  final status = ref.watch(connectivityStatusProvider);
  return status.when(
    data: (isConnected) => isConnected,
    loading: () => true,
    error: (_, __) => true,
  );
}
