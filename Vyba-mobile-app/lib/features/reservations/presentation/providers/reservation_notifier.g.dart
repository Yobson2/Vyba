// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reservationNotifierHash() =>
    r'7ebe74ba36ad331bd1eca1e8dce1c7a959fa0797';

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

abstract class _$ReservationNotifier
    extends BuildlessAutoDisposeNotifier<ReservationState> {
  late final String venueId;

  ReservationState build(
    String venueId,
  );
}

/// One venue's reservation state, keyed by venueId.
///
/// Copied from [ReservationNotifier].
@ProviderFor(ReservationNotifier)
const reservationNotifierProvider = ReservationNotifierFamily();

/// One venue's reservation state, keyed by venueId.
///
/// Copied from [ReservationNotifier].
class ReservationNotifierFamily extends Family<ReservationState> {
  /// One venue's reservation state, keyed by venueId.
  ///
  /// Copied from [ReservationNotifier].
  const ReservationNotifierFamily();

  /// One venue's reservation state, keyed by venueId.
  ///
  /// Copied from [ReservationNotifier].
  ReservationNotifierProvider call(
    String venueId,
  ) {
    return ReservationNotifierProvider(
      venueId,
    );
  }

  @override
  ReservationNotifierProvider getProviderOverride(
    covariant ReservationNotifierProvider provider,
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
  String? get name => r'reservationNotifierProvider';
}

/// One venue's reservation state, keyed by venueId.
///
/// Copied from [ReservationNotifier].
class ReservationNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ReservationNotifier, ReservationState> {
  /// One venue's reservation state, keyed by venueId.
  ///
  /// Copied from [ReservationNotifier].
  ReservationNotifierProvider(
    String venueId,
  ) : this._internal(
          () => ReservationNotifier()..venueId = venueId,
          from: reservationNotifierProvider,
          name: r'reservationNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reservationNotifierHash,
          dependencies: ReservationNotifierFamily._dependencies,
          allTransitiveDependencies:
              ReservationNotifierFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  ReservationNotifierProvider._internal(
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
  ReservationState runNotifierBuild(
    covariant ReservationNotifier notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(ReservationNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReservationNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<ReservationNotifier, ReservationState>
      createElement() {
    return _ReservationNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReservationNotifierProvider && other.venueId == venueId;
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
mixin ReservationNotifierRef
    on AutoDisposeNotifierProviderRef<ReservationState> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _ReservationNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ReservationNotifier,
        ReservationState> with ReservationNotifierRef {
  _ReservationNotifierProviderElement(super.provider);

  @override
  String get venueId => (origin as ReservationNotifierProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
