// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncEngineHash() => r'65490542641bee7389abd05a9d9671a9b9f61253';

/// Provides the [SyncEngine] singleton.
///
/// Features register their [SyncHandler] implementations
/// during provider initialization.
///
/// Copied from [syncEngine].
@ProviderFor(syncEngine)
final syncEngineProvider = Provider<SyncEngine>.internal(
  syncEngine,
  name: r'syncEngineProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncEngineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncEngineRef = ProviderRef<SyncEngine>;
String _$syncStatusHash() => r'bf656d81ec99f09b8c2e684f4f4ef8c40b20d3e9';

/// Streams the current [SyncStatus] for UI widgets.
///
/// Copied from [syncStatus].
@ProviderFor(syncStatus)
final syncStatusProvider = AutoDisposeStreamProvider<SyncStatus>.internal(
  syncStatus,
  name: r'syncStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncStatusRef = AutoDisposeStreamProviderRef<SyncStatus>;
String _$pendingSyncCountHash() => r'ec197835d59646a205e5e44c40daf090d32d7fb0';

/// Provides the count of pending sync operations for badges.
///
/// Copied from [pendingSyncCount].
@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = AutoDisposeStreamProvider<int>.internal(
  pendingSyncCount,
  name: r'pendingSyncCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingSyncCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingSyncCountRef = AutoDisposeStreamProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
