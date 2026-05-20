// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$venueDetailNotifierHash() =>
    r'8b789bf83ad6416f2a6cabde9ff490c702c9ba47';

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

abstract class _$VenueDetailNotifier
    extends BuildlessAutoDisposeNotifier<VenueDetailState> {
  late final String venueId;

  VenueDetailState build(
    String venueId,
  );
}

/// See also [VenueDetailNotifier].
@ProviderFor(VenueDetailNotifier)
const venueDetailNotifierProvider = VenueDetailNotifierFamily();

/// See also [VenueDetailNotifier].
class VenueDetailNotifierFamily extends Family<VenueDetailState> {
  /// See also [VenueDetailNotifier].
  const VenueDetailNotifierFamily();

  /// See also [VenueDetailNotifier].
  VenueDetailNotifierProvider call(
    String venueId,
  ) {
    return VenueDetailNotifierProvider(
      venueId,
    );
  }

  @override
  VenueDetailNotifierProvider getProviderOverride(
    covariant VenueDetailNotifierProvider provider,
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
  String? get name => r'venueDetailNotifierProvider';
}

/// See also [VenueDetailNotifier].
class VenueDetailNotifierProvider extends AutoDisposeNotifierProviderImpl<
    VenueDetailNotifier, VenueDetailState> {
  /// See also [VenueDetailNotifier].
  VenueDetailNotifierProvider(
    String venueId,
  ) : this._internal(
          () => VenueDetailNotifier()..venueId = venueId,
          from: venueDetailNotifierProvider,
          name: r'venueDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$venueDetailNotifierHash,
          dependencies: VenueDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              VenueDetailNotifierFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  VenueDetailNotifierProvider._internal(
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
  VenueDetailState runNotifierBuild(
    covariant VenueDetailNotifier notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(VenueDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VenueDetailNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<VenueDetailNotifier, VenueDetailState>
      createElement() {
    return _VenueDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueDetailNotifierProvider && other.venueId == venueId;
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
mixin VenueDetailNotifierRef
    on AutoDisposeNotifierProviderRef<VenueDetailState> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _VenueDetailNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<VenueDetailNotifier,
        VenueDetailState> with VenueDetailNotifierRef {
  _VenueDetailNotifierProviderElement(super.provider);

  @override
  String get venueId => (origin as VenueDetailNotifierProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
