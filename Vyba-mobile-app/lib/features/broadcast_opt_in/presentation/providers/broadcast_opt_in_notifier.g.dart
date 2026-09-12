// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_opt_in_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$broadcastOptInNotifierHash() =>
    r'ac5466dd6ee34b83b44e50d24385f540ad9bec4d';

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

abstract class _$BroadcastOptInNotifier
    extends BuildlessAutoDisposeNotifier<BroadcastOptInState> {
  late final String venueId;

  BroadcastOptInState build(
    String venueId,
  );
}

/// Broadcast opt-in toggle for one venue, keyed by venueId (ticket 17) —
/// optimistic with rollback on failure, mirroring `FollowNotifier` exactly
/// except this is a wholly separate choice from following.
///
/// Copied from [BroadcastOptInNotifier].
@ProviderFor(BroadcastOptInNotifier)
const broadcastOptInNotifierProvider = BroadcastOptInNotifierFamily();

/// Broadcast opt-in toggle for one venue, keyed by venueId (ticket 17) —
/// optimistic with rollback on failure, mirroring `FollowNotifier` exactly
/// except this is a wholly separate choice from following.
///
/// Copied from [BroadcastOptInNotifier].
class BroadcastOptInNotifierFamily extends Family<BroadcastOptInState> {
  /// Broadcast opt-in toggle for one venue, keyed by venueId (ticket 17) —
  /// optimistic with rollback on failure, mirroring `FollowNotifier` exactly
  /// except this is a wholly separate choice from following.
  ///
  /// Copied from [BroadcastOptInNotifier].
  const BroadcastOptInNotifierFamily();

  /// Broadcast opt-in toggle for one venue, keyed by venueId (ticket 17) —
  /// optimistic with rollback on failure, mirroring `FollowNotifier` exactly
  /// except this is a wholly separate choice from following.
  ///
  /// Copied from [BroadcastOptInNotifier].
  BroadcastOptInNotifierProvider call(
    String venueId,
  ) {
    return BroadcastOptInNotifierProvider(
      venueId,
    );
  }

  @override
  BroadcastOptInNotifierProvider getProviderOverride(
    covariant BroadcastOptInNotifierProvider provider,
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
  String? get name => r'broadcastOptInNotifierProvider';
}

/// Broadcast opt-in toggle for one venue, keyed by venueId (ticket 17) —
/// optimistic with rollback on failure, mirroring `FollowNotifier` exactly
/// except this is a wholly separate choice from following.
///
/// Copied from [BroadcastOptInNotifier].
class BroadcastOptInNotifierProvider extends AutoDisposeNotifierProviderImpl<
    BroadcastOptInNotifier, BroadcastOptInState> {
  /// Broadcast opt-in toggle for one venue, keyed by venueId (ticket 17) —
  /// optimistic with rollback on failure, mirroring `FollowNotifier` exactly
  /// except this is a wholly separate choice from following.
  ///
  /// Copied from [BroadcastOptInNotifier].
  BroadcastOptInNotifierProvider(
    String venueId,
  ) : this._internal(
          () => BroadcastOptInNotifier()..venueId = venueId,
          from: broadcastOptInNotifierProvider,
          name: r'broadcastOptInNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$broadcastOptInNotifierHash,
          dependencies: BroadcastOptInNotifierFamily._dependencies,
          allTransitiveDependencies:
              BroadcastOptInNotifierFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  BroadcastOptInNotifierProvider._internal(
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
  BroadcastOptInState runNotifierBuild(
    covariant BroadcastOptInNotifier notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(BroadcastOptInNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BroadcastOptInNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<BroadcastOptInNotifier,
      BroadcastOptInState> createElement() {
    return _BroadcastOptInNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BroadcastOptInNotifierProvider && other.venueId == venueId;
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
mixin BroadcastOptInNotifierRef
    on AutoDisposeNotifierProviderRef<BroadcastOptInState> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _BroadcastOptInNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<BroadcastOptInNotifier,
        BroadcastOptInState> with BroadcastOptInNotifierRef {
  _BroadcastOptInNotifierProviderElement(super.provider);

  @override
  String get venueId => (origin as BroadcastOptInNotifierProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
