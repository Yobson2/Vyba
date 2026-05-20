// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_booking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownerBookingDataSourceHash() =>
    r'f798f294bff211d5ed3eb64954595e28d79cc82a';

/// See also [ownerBookingDataSource].
@ProviderFor(ownerBookingDataSource)
final ownerBookingDataSourceProvider =
    Provider<OwnerBookingDataSource>.internal(
  ownerBookingDataSource,
  name: r'ownerBookingDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ownerBookingDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OwnerBookingDataSourceRef = ProviderRef<OwnerBookingDataSource>;
String _$ownerBookingRepositoryHash() =>
    r'e064d22dcc40bfc2e5f3cc34aa2b5a9e02e498f2';

/// See also [ownerBookingRepository].
@ProviderFor(ownerBookingRepository)
final ownerBookingRepositoryProvider =
    Provider<OwnerBookingRepository>.internal(
  ownerBookingRepository,
  name: r'ownerBookingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ownerBookingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OwnerBookingRepositoryRef = ProviderRef<OwnerBookingRepository>;
String _$ownerBookingsHash() => r'f3fa5acd9980f8b342ab86a7cb73434ebc0961a5';

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

/// See also [ownerBookings].
@ProviderFor(ownerBookings)
const ownerBookingsProvider = OwnerBookingsFamily();

/// See also [ownerBookings].
class OwnerBookingsFamily extends Family<AsyncValue<List<OwnerBooking>>> {
  /// See also [ownerBookings].
  const OwnerBookingsFamily();

  /// See also [ownerBookings].
  OwnerBookingsProvider call({
    String? filter,
  }) {
    return OwnerBookingsProvider(
      filter: filter,
    );
  }

  @override
  OwnerBookingsProvider getProviderOverride(
    covariant OwnerBookingsProvider provider,
  ) {
    return call(
      filter: provider.filter,
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
  String? get name => r'ownerBookingsProvider';
}

/// See also [ownerBookings].
class OwnerBookingsProvider
    extends AutoDisposeFutureProvider<List<OwnerBooking>> {
  /// See also [ownerBookings].
  OwnerBookingsProvider({
    String? filter,
  }) : this._internal(
          (ref) => ownerBookings(
            ref as OwnerBookingsRef,
            filter: filter,
          ),
          from: ownerBookingsProvider,
          name: r'ownerBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ownerBookingsHash,
          dependencies: OwnerBookingsFamily._dependencies,
          allTransitiveDependencies:
              OwnerBookingsFamily._allTransitiveDependencies,
          filter: filter,
        );

  OwnerBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final String? filter;

  @override
  Override overrideWith(
    FutureOr<List<OwnerBooking>> Function(OwnerBookingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnerBookingsProvider._internal(
        (ref) => create(ref as OwnerBookingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<OwnerBooking>> createElement() {
    return _OwnerBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnerBookingsProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OwnerBookingsRef on AutoDisposeFutureProviderRef<List<OwnerBooking>> {
  /// The parameter `filter` of this provider.
  String? get filter;
}

class _OwnerBookingsProviderElement
    extends AutoDisposeFutureProviderElement<List<OwnerBooking>>
    with OwnerBookingsRef {
  _OwnerBookingsProviderElement(super.provider);

  @override
  String? get filter => (origin as OwnerBookingsProvider).filter;
}

String _$ownerBookingActionsHash() =>
    r'66c310339a80f77dfb2095762d73a0b773bc3785';

/// See also [OwnerBookingActions].
@ProviderFor(OwnerBookingActions)
final ownerBookingActionsProvider =
    AutoDisposeAsyncNotifierProvider<OwnerBookingActions, void>.internal(
  OwnerBookingActions.new,
  name: r'ownerBookingActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ownerBookingActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OwnerBookingActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
