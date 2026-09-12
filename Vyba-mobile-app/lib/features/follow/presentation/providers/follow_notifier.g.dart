// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followNotifierHash() => r'bbae79e2794380771abc127c8af045d6bd654ad0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FollowNotifier
    extends BuildlessAutoDisposeNotifier<FollowState> {
  late final String venueId;

  FollowState build(
    String venueId,
  );
}

/// Follow toggle for one venue, keyed by venueId — optimistic with rollback
/// on failure, idempotent (ticket 10). `venue_followed`/`venue_unfollowed`
/// are emitted server-side by `FollowsService` (ticket 11), not duplicated
/// here.
///
/// Copied from [FollowNotifier].
@ProviderFor(FollowNotifier)
const followNotifierProvider = FollowNotifierFamily();

/// Follow toggle for one venue, keyed by venueId — optimistic with rollback
/// on failure, idempotent (ticket 10). `venue_followed`/`venue_unfollowed`
/// are emitted server-side by `FollowsService` (ticket 11), not duplicated
/// here.
///
/// Copied from [FollowNotifier].
class FollowNotifierFamily extends Family<FollowState> {
  /// Follow toggle for one venue, keyed by venueId — optimistic with rollback
  /// on failure, idempotent (ticket 10). `venue_followed`/`venue_unfollowed`
  /// are emitted server-side by `FollowsService` (ticket 11), not duplicated
  /// here.
  ///
  /// Copied from [FollowNotifier].
  const FollowNotifierFamily();

  /// Follow toggle for one venue, keyed by venueId — optimistic with rollback
  /// on failure, idempotent (ticket 10). `venue_followed`/`venue_unfollowed`
  /// are emitted server-side by `FollowsService` (ticket 11), not duplicated
  /// here.
  ///
  /// Copied from [FollowNotifier].
  FollowNotifierProvider call(
    String venueId,
  ) {
    return FollowNotifierProvider(
      venueId,
    );
  }

  @override
  FollowNotifierProvider getProviderOverride(
    covariant FollowNotifierProvider provider,
  ) {
    return call(
      provider.venueId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'followNotifierProvider';
}

/// Follow toggle for one venue, keyed by venueId — optimistic with rollback
/// on failure, idempotent (ticket 10). `venue_followed`/`venue_unfollowed`
/// are emitted server-side by `FollowsService` (ticket 11), not duplicated
/// here.
///
/// Copied from [FollowNotifier].
class FollowNotifierProvider
    extends AutoDisposeNotifierProviderImpl<FollowNotifier, FollowState> {
  /// Follow toggle for one venue, keyed by venueId — optimistic with rollback
  /// on failure, idempotent (ticket 10). `venue_followed`/`venue_unfollowed`
  /// are emitted server-side by `FollowsService` (ticket 11), not duplicated
  /// here.
  ///
  /// Copied from [FollowNotifier].
  FollowNotifierProvider(
    String venueId,
  ) : this._internal(
          () => FollowNotifier()..venueId = venueId,
          from: followNotifierProvider,
          name: r'followNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followNotifierHash,
          dependencies: FollowNotifierFamily._dependencies,
          allTransitiveDependencies:
              FollowNotifierFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  FollowNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.venueId,
  }) : super.internal();

  final String venueId;

  @override
  FollowState runNotifierBuild(
    covariant FollowNotifier notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(FollowNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: FollowNotifierProvider._internal(
        () => create()..venueId = venueId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        venueId: venueId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FollowNotifier, FollowState>
      createElement() {
    return _FollowNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowNotifierProvider && other.venueId == venueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, venueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FollowNotifierRef on AutoDisposeNotifierProviderRef<FollowState> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _FollowNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<FollowNotifier, FollowState>
    with FollowNotifierRef {
  _FollowNotifierProviderElement(super.provider);

  @override
  String get venueId => (origin as FollowNotifierProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
