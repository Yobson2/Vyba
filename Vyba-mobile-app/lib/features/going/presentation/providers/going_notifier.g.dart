// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'going_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goingNotifierHash() => r'd990da075a6dc24409db49f862d2400dd1988e9f';

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

abstract class _$GoingNotifier
    extends BuildlessAutoDisposeNotifier<GoingState> {
  late final String venueId;

  GoingState build(
    String venueId,
  );
}

/// One venue's "J'y vais" state, keyed by venueId.
///
/// Copied from [GoingNotifier].
@ProviderFor(GoingNotifier)
const goingNotifierProvider = GoingNotifierFamily();

/// One venue's "J'y vais" state, keyed by venueId.
///
/// Copied from [GoingNotifier].
class GoingNotifierFamily extends Family<GoingState> {
  /// One venue's "J'y vais" state, keyed by venueId.
  ///
  /// Copied from [GoingNotifier].
  const GoingNotifierFamily();

  /// One venue's "J'y vais" state, keyed by venueId.
  ///
  /// Copied from [GoingNotifier].
  GoingNotifierProvider call(
    String venueId,
  ) {
    return GoingNotifierProvider(
      venueId,
    );
  }

  @override
  GoingNotifierProvider getProviderOverride(
    covariant GoingNotifierProvider provider,
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
  String? get name => r'goingNotifierProvider';
}

/// One venue's "J'y vais" state, keyed by venueId.
///
/// Copied from [GoingNotifier].
class GoingNotifierProvider
    extends AutoDisposeNotifierProviderImpl<GoingNotifier, GoingState> {
  /// One venue's "J'y vais" state, keyed by venueId.
  ///
  /// Copied from [GoingNotifier].
  GoingNotifierProvider(
    String venueId,
  ) : this._internal(
          () => GoingNotifier()..venueId = venueId,
          from: goingNotifierProvider,
          name: r'goingNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$goingNotifierHash,
          dependencies: GoingNotifierFamily._dependencies,
          allTransitiveDependencies:
              GoingNotifierFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  GoingNotifierProvider._internal(
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
  GoingState runNotifierBuild(
    covariant GoingNotifier notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(GoingNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GoingNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<GoingNotifier, GoingState>
      createElement() {
    return _GoingNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoingNotifierProvider && other.venueId == venueId;
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
mixin GoingNotifierRef on AutoDisposeNotifierProviderRef<GoingState> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _GoingNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<GoingNotifier, GoingState>
    with GoingNotifierRef {
  _GoingNotifierProviderElement(super.provider);

  @override
  String get venueId => (origin as GoingNotifierProvider).venueId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
