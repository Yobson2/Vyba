// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsDataSourceHash() =>
    r'027147fb03d9a4489c785ef2d7379a3271d857b6';

/// See also [analyticsDataSource].
@ProviderFor(analyticsDataSource)
final analyticsDataSourceProvider = Provider<AnalyticsDataSource>.internal(
  analyticsDataSource,
  name: r'analyticsDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsDataSourceRef = ProviderRef<AnalyticsDataSource>;
String _$analyticsRepositoryHash() =>
    r'963d5fa5f26416efc8288cdb5b0972d089c0925e';

/// See also [analyticsRepository].
@ProviderFor(analyticsRepository)
final analyticsRepositoryProvider = Provider<AnalyticsRepository>.internal(
  analyticsRepository,
  name: r'analyticsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsRepositoryRef = ProviderRef<AnalyticsRepository>;
String _$ownerAnalyticsHash() => r'76052584782ba477830884ccb038ec0e15e8d20a';

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

/// See also [ownerAnalytics].
@ProviderFor(ownerAnalytics)
const ownerAnalyticsProvider = OwnerAnalyticsFamily();

/// See also [ownerAnalytics].
class OwnerAnalyticsFamily extends Family<AsyncValue<AnalyticsData>> {
  /// See also [ownerAnalytics].
  const OwnerAnalyticsFamily();

  /// See also [ownerAnalytics].
  OwnerAnalyticsProvider call({
    String? dateRange,
  }) {
    return OwnerAnalyticsProvider(
      dateRange: dateRange,
    );
  }

  @override
  OwnerAnalyticsProvider getProviderOverride(
    covariant OwnerAnalyticsProvider provider,
  ) {
    return call(
      dateRange: provider.dateRange,
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
  String? get name => r'ownerAnalyticsProvider';
}

/// See also [ownerAnalytics].
class OwnerAnalyticsProvider extends AutoDisposeFutureProvider<AnalyticsData> {
  /// See also [ownerAnalytics].
  OwnerAnalyticsProvider({
    String? dateRange,
  }) : this._internal(
          (ref) => ownerAnalytics(
            ref as OwnerAnalyticsRef,
            dateRange: dateRange,
          ),
          from: ownerAnalyticsProvider,
          name: r'ownerAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ownerAnalyticsHash,
          dependencies: OwnerAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              OwnerAnalyticsFamily._allTransitiveDependencies,
          dateRange: dateRange,
        );

  OwnerAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dateRange,
  }) : super.internal();

  final String? dateRange;

  @override
  Override overrideWith(
    FutureOr<AnalyticsData> Function(OwnerAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnerAnalyticsProvider._internal(
        (ref) => create(ref as OwnerAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dateRange: dateRange,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AnalyticsData> createElement() {
    return _OwnerAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnerAnalyticsProvider && other.dateRange == dateRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OwnerAnalyticsRef on AutoDisposeFutureProviderRef<AnalyticsData> {
  /// The parameter `dateRange` of this provider.
  String? get dateRange;
}

class _OwnerAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<AnalyticsData>
    with OwnerAnalyticsRef {
  _OwnerAnalyticsProviderElement(super.provider);

  @override
  String? get dateRange => (origin as OwnerAnalyticsProvider).dateRange;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
