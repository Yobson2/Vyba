// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_going_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownerGoingSummaryHash() => r'9403121e236f03a39950a55b2e4a4260ec8dc9d5';

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

/// Rough party sizes for the owner home (ticket 08) — the going count itself
/// already rides along on `VenueNightNotifier`'s state; this adds just the
/// party-size texture.
///
/// Copied from [ownerGoingSummary].
@ProviderFor(ownerGoingSummary)
const ownerGoingSummaryProvider = OwnerGoingSummaryFamily();

/// Rough party sizes for the owner home (ticket 08) — the going count itself
/// already rides along on `VenueNightNotifier`'s state; this adds just the
/// party-size texture.
///
/// Copied from [ownerGoingSummary].
class OwnerGoingSummaryFamily extends Family<AsyncValue<List<int>>> {
  /// Rough party sizes for the owner home (ticket 08) — the going count itself
  /// already rides along on `VenueNightNotifier`'s state; this adds just the
  /// party-size texture.
  ///
  /// Copied from [ownerGoingSummary].
  const OwnerGoingSummaryFamily();

  /// Rough party sizes for the owner home (ticket 08) — the going count itself
  /// already rides along on `VenueNightNotifier`'s state; this adds just the
  /// party-size texture.
  ///
  /// Copied from [ownerGoingSummary].
  OwnerGoingSummaryProvider call(
    String venueId,
  ) {
    return OwnerGoingSummaryProvider(
      venueId,
    );
  }

  @override
  OwnerGoingSummaryProvider getProviderOverride(
    covariant OwnerGoingSummaryProvider provider,
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
  String? get name => r'ownerGoingSummaryProvider';
}

/// Rough party sizes for the owner home (ticket 08) — the going count itself
/// already rides along on `VenueNightNotifier`'s state; this adds just the
/// party-size texture.
///
/// Copied from [ownerGoingSummary].
class OwnerGoingSummaryProvider extends AutoDisposeFutureProvider<List<int>> {
  /// Rough party sizes for the owner home (ticket 08) — the going count itself
  /// already rides along on `VenueNightNotifier`'s state; this adds just the
  /// party-size texture.
  ///
  /// Copied from [ownerGoingSummary].
  OwnerGoingSummaryProvider(
    String venueId,
  ) : this._internal(
          (ref) => ownerGoingSummary(
            ref as OwnerGoingSummaryRef,
            venueId,
          ),
          from: ownerGoingSummaryProvider,
          name: r'ownerGoingSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ownerGoingSummaryHash,
          dependencies: OwnerGoingSummaryFamily._dependencies,
          allTransitiveDependencies:
              OwnerGoingSummaryFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  OwnerGoingSummaryProvider._internal(
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
    FutureOr<List<int>> Function(OwnerGoingSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnerGoingSummaryProvider._internal(
        (ref) => create(ref as OwnerGoingSummaryRef),
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
  AutoDisposeFutureProviderElement<List<int>> createElement() {
    return _OwnerGoingSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnerGoingSummaryProvider && other.venueId == venueId;
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
mixin OwnerGoingSummaryRef on AutoDisposeFutureProviderRef<List<int>> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _OwnerGoingSummaryProviderElement
    extends AutoDisposeFutureProviderElement<List<int>>
    with OwnerGoingSummaryRef {
  _OwnerGoingSummaryProviderElement(super.provider);

  @override
  String get venueId => (origin as OwnerGoingSummaryProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
