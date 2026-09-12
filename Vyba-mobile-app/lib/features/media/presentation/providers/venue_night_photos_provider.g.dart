// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_night_photos_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$venueNightPhotosHash() => r'9b914d54f188a7a7568b65f5960a46b0ad63cb36';

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

/// Tonight's active user photos for a venue — the venue/night view seam
/// (ticket 14). Refetched after a successful upload via `AddPhotoNotifier`.
///
/// Copied from [venueNightPhotos].
@ProviderFor(venueNightPhotos)
const venueNightPhotosProvider = VenueNightPhotosFamily();

/// Tonight's active user photos for a venue — the venue/night view seam
/// (ticket 14). Refetched after a successful upload via `AddPhotoNotifier`.
///
/// Copied from [venueNightPhotos].
class VenueNightPhotosFamily extends Family<AsyncValue<List<VenueNightPhoto>>> {
  /// Tonight's active user photos for a venue — the venue/night view seam
  /// (ticket 14). Refetched after a successful upload via `AddPhotoNotifier`.
  ///
  /// Copied from [venueNightPhotos].
  const VenueNightPhotosFamily();

  /// Tonight's active user photos for a venue — the venue/night view seam
  /// (ticket 14). Refetched after a successful upload via `AddPhotoNotifier`.
  ///
  /// Copied from [venueNightPhotos].
  VenueNightPhotosProvider call(
    String venueId,
  ) {
    return VenueNightPhotosProvider(
      venueId,
    );
  }

  @override
  VenueNightPhotosProvider getProviderOverride(
    covariant VenueNightPhotosProvider provider,
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
  String? get name => r'venueNightPhotosProvider';
}

/// Tonight's active user photos for a venue — the venue/night view seam
/// (ticket 14). Refetched after a successful upload via `AddPhotoNotifier`.
///
/// Copied from [venueNightPhotos].
class VenueNightPhotosProvider
    extends AutoDisposeFutureProvider<List<VenueNightPhoto>> {
  /// Tonight's active user photos for a venue — the venue/night view seam
  /// (ticket 14). Refetched after a successful upload via `AddPhotoNotifier`.
  ///
  /// Copied from [venueNightPhotos].
  VenueNightPhotosProvider(
    String venueId,
  ) : this._internal(
          (ref) => venueNightPhotos(
            ref as VenueNightPhotosRef,
            venueId,
          ),
          from: venueNightPhotosProvider,
          name: r'venueNightPhotosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$venueNightPhotosHash,
          dependencies: VenueNightPhotosFamily._dependencies,
          allTransitiveDependencies:
              VenueNightPhotosFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  VenueNightPhotosProvider._internal(
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
    FutureOr<List<VenueNightPhoto>> Function(VenueNightPhotosRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VenueNightPhotosProvider._internal(
        (ref) => create(ref as VenueNightPhotosRef),
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
  AutoDisposeFutureProviderElement<List<VenueNightPhoto>> createElement() {
    return _VenueNightPhotosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueNightPhotosProvider && other.venueId == venueId;
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
mixin VenueNightPhotosRef
    on AutoDisposeFutureProviderRef<List<VenueNightPhoto>> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _VenueNightPhotosProviderElement
    extends AutoDisposeFutureProviderElement<List<VenueNightPhoto>>
    with VenueNightPhotosRef {
  _VenueNightPhotosProviderElement(super.provider);

  @override
  String get venueId => (origin as VenueNightPhotosProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
