// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_reservations_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownerReservationsNotifierHash() =>
    r'4199e6f83f5af0c70d9c3e3c7fe3201102d2b462';

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

abstract class _$OwnerReservationsNotifier
    extends BuildlessAutoDisposeNotifier<OwnerReservationsState> {
  late final String venueId;

  OwnerReservationsState build(
    String venueId,
  );
}

/// Tonight's reservation requests for the owner's own venue — list +
/// confirm/reject, keyed by venueId.
///
/// Copied from [OwnerReservationsNotifier].
@ProviderFor(OwnerReservationsNotifier)
const ownerReservationsNotifierProvider = OwnerReservationsNotifierFamily();

/// Tonight's reservation requests for the owner's own venue — list +
/// confirm/reject, keyed by venueId.
///
/// Copied from [OwnerReservationsNotifier].
class OwnerReservationsNotifierFamily extends Family<OwnerReservationsState> {
  /// Tonight's reservation requests for the owner's own venue — list +
  /// confirm/reject, keyed by venueId.
  ///
  /// Copied from [OwnerReservationsNotifier].
  const OwnerReservationsNotifierFamily();

  /// Tonight's reservation requests for the owner's own venue — list +
  /// confirm/reject, keyed by venueId.
  ///
  /// Copied from [OwnerReservationsNotifier].
  OwnerReservationsNotifierProvider call(
    String venueId,
  ) {
    return OwnerReservationsNotifierProvider(
      venueId,
    );
  }

  @override
  OwnerReservationsNotifierProvider getProviderOverride(
    covariant OwnerReservationsNotifierProvider provider,
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
  String? get name => r'ownerReservationsNotifierProvider';
}

/// Tonight's reservation requests for the owner's own venue — list +
/// confirm/reject, keyed by venueId.
///
/// Copied from [OwnerReservationsNotifier].
class OwnerReservationsNotifierProvider extends AutoDisposeNotifierProviderImpl<
    OwnerReservationsNotifier, OwnerReservationsState> {
  /// Tonight's reservation requests for the owner's own venue — list +
  /// confirm/reject, keyed by venueId.
  ///
  /// Copied from [OwnerReservationsNotifier].
  OwnerReservationsNotifierProvider(
    String venueId,
  ) : this._internal(
          () => OwnerReservationsNotifier()..venueId = venueId,
          from: ownerReservationsNotifierProvider,
          name: r'ownerReservationsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ownerReservationsNotifierHash,
          dependencies: OwnerReservationsNotifierFamily._dependencies,
          allTransitiveDependencies:
              OwnerReservationsNotifierFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  OwnerReservationsNotifierProvider._internal(
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
  OwnerReservationsState runNotifierBuild(
    covariant OwnerReservationsNotifier notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(OwnerReservationsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: OwnerReservationsNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<OwnerReservationsNotifier,
      OwnerReservationsState> createElement() {
    return _OwnerReservationsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnerReservationsNotifierProvider &&
        other.venueId == venueId;
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
mixin OwnerReservationsNotifierRef
    on AutoDisposeNotifierProviderRef<OwnerReservationsState> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _OwnerReservationsNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<OwnerReservationsNotifier,
        OwnerReservationsState> with OwnerReservationsNotifierRef {
  _OwnerReservationsNotifierProviderElement(super.provider);

  @override
  String get venueId => (origin as OwnerReservationsNotifierProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
