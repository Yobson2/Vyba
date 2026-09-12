// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_photo_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addPhotoNotifierHash() => r'81f713a88f13d901731e047ef0cf255728f1328d';

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

abstract class _$AddPhotoNotifier
    extends BuildlessAutoDisposeNotifier<AddPhotoState> {
  late final String venueId;

  AddPhotoState build(
    String venueId,
  );
}

/// "Ajouter une photo" for one venue (ticket 14) — on success, refreshes
/// [venueNightPhotosProvider] for the same venue so it shows immediately.
///
/// Copied from [AddPhotoNotifier].
@ProviderFor(AddPhotoNotifier)
const addPhotoNotifierProvider = AddPhotoNotifierFamily();

/// "Ajouter une photo" for one venue (ticket 14) — on success, refreshes
/// [venueNightPhotosProvider] for the same venue so it shows immediately.
///
/// Copied from [AddPhotoNotifier].
class AddPhotoNotifierFamily extends Family<AddPhotoState> {
  /// "Ajouter une photo" for one venue (ticket 14) — on success, refreshes
  /// [venueNightPhotosProvider] for the same venue so it shows immediately.
  ///
  /// Copied from [AddPhotoNotifier].
  const AddPhotoNotifierFamily();

  /// "Ajouter une photo" for one venue (ticket 14) — on success, refreshes
  /// [venueNightPhotosProvider] for the same venue so it shows immediately.
  ///
  /// Copied from [AddPhotoNotifier].
  AddPhotoNotifierProvider call(
    String venueId,
  ) {
    return AddPhotoNotifierProvider(
      venueId,
    );
  }

  @override
  AddPhotoNotifierProvider getProviderOverride(
    covariant AddPhotoNotifierProvider provider,
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
  String? get name => r'addPhotoNotifierProvider';
}

/// "Ajouter une photo" for one venue (ticket 14) — on success, refreshes
/// [venueNightPhotosProvider] for the same venue so it shows immediately.
///
/// Copied from [AddPhotoNotifier].
class AddPhotoNotifierProvider
    extends AutoDisposeNotifierProviderImpl<AddPhotoNotifier, AddPhotoState> {
  /// "Ajouter une photo" for one venue (ticket 14) — on success, refreshes
  /// [venueNightPhotosProvider] for the same venue so it shows immediately.
  ///
  /// Copied from [AddPhotoNotifier].
  AddPhotoNotifierProvider(
    String venueId,
  ) : this._internal(
          () => AddPhotoNotifier()..venueId = venueId,
          from: addPhotoNotifierProvider,
          name: r'addPhotoNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addPhotoNotifierHash,
          dependencies: AddPhotoNotifierFamily._dependencies,
          allTransitiveDependencies:
              AddPhotoNotifierFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  AddPhotoNotifierProvider._internal(
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
  AddPhotoState runNotifierBuild(
    covariant AddPhotoNotifier notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(AddPhotoNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AddPhotoNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<AddPhotoNotifier, AddPhotoState>
      createElement() {
    return _AddPhotoNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddPhotoNotifierProvider && other.venueId == venueId;
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
mixin AddPhotoNotifierRef on AutoDisposeNotifierProviderRef<AddPhotoState> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _AddPhotoNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<AddPhotoNotifier, AddPhotoState>
    with AddPhotoNotifierRef {
  _AddPhotoNotifierProviderElement(super.provider);

  @override
  String get venueId => (origin as AddPhotoNotifierProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
