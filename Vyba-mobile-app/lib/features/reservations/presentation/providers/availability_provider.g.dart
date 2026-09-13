// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availabilityHash() => r'158d4a805283084b9acf411629d8e48402d6b046';

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

/// Tonight's confirmed-reservation load for [venueId] — only fetched by the
/// UI when the venue is `reservationsEnabled` (most venues never pay this
/// extra call).
///
/// Copied from [availability].
@ProviderFor(availability)
const availabilityProvider = AvailabilityFamily();

/// Tonight's confirmed-reservation load for [venueId] — only fetched by the
/// UI when the venue is `reservationsEnabled` (most venues never pay this
/// extra call).
///
/// Copied from [availability].
class AvailabilityFamily extends Family<AsyncValue<Availability>> {
  /// Tonight's confirmed-reservation load for [venueId] — only fetched by the
  /// UI when the venue is `reservationsEnabled` (most venues never pay this
  /// extra call).
  ///
  /// Copied from [availability].
  const AvailabilityFamily();

  /// Tonight's confirmed-reservation load for [venueId] — only fetched by the
  /// UI when the venue is `reservationsEnabled` (most venues never pay this
  /// extra call).
  ///
  /// Copied from [availability].
  AvailabilityProvider call(
    String venueId,
  ) {
    return AvailabilityProvider(
      venueId,
    );
  }

  @override
  AvailabilityProvider getProviderOverride(
    covariant AvailabilityProvider provider,
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
  String? get name => r'availabilityProvider';
}

/// Tonight's confirmed-reservation load for [venueId] — only fetched by the
/// UI when the venue is `reservationsEnabled` (most venues never pay this
/// extra call).
///
/// Copied from [availability].
class AvailabilityProvider extends AutoDisposeFutureProvider<Availability> {
  /// Tonight's confirmed-reservation load for [venueId] — only fetched by the
  /// UI when the venue is `reservationsEnabled` (most venues never pay this
  /// extra call).
  ///
  /// Copied from [availability].
  AvailabilityProvider(
    String venueId,
  ) : this._internal(
          (ref) => availability(
            ref as AvailabilityRef,
            venueId,
          ),
          from: availabilityProvider,
          name: r'availabilityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availabilityHash,
          dependencies: AvailabilityFamily._dependencies,
          allTransitiveDependencies:
              AvailabilityFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  AvailabilityProvider._internal(
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
  Override overrideWith(
    FutureOr<Availability> Function(AvailabilityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailabilityProvider._internal(
        (ref) => create(ref as AvailabilityRef),
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
  AutoDisposeFutureProviderElement<Availability> createElement() {
    return _AvailabilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailabilityProvider && other.venueId == venueId;
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
mixin AvailabilityRef on AutoDisposeFutureProviderRef<Availability> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _AvailabilityProviderElement
    extends AutoDisposeFutureProviderElement<Availability>
    with AvailabilityRef {
  _AvailabilityProviderElement(super.provider);

  @override
  String get venueId => (origin as AvailabilityProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
