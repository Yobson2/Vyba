// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_management_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$venueManagementDataSourceHash() =>
    r'2e35b49b0c0e8feb6f946b17579e79067574d53a';

/// See also [venueManagementDataSource].
@ProviderFor(venueManagementDataSource)
final venueManagementDataSourceProvider =
    Provider<VenueManagementDataSource>.internal(
  venueManagementDataSource,
  name: r'venueManagementDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venueManagementDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VenueManagementDataSourceRef = ProviderRef<VenueManagementDataSource>;
String _$venueManagementRepositoryHash() =>
    r'6c91a974147a9cc8dcce48ca0c9ca2405a4e87d4';

/// See also [venueManagementRepository].
@ProviderFor(venueManagementRepository)
final venueManagementRepositoryProvider =
    Provider<VenueManagementRepository>.internal(
  venueManagementRepository,
  name: r'venueManagementRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venueManagementRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VenueManagementRepositoryRef = ProviderRef<VenueManagementRepository>;
String _$myVenuesHash() => r'c79111769757be28f64d61f2ccbeffe52e9817d3';

/// See also [myVenues].
@ProviderFor(myVenues)
final myVenuesProvider = AutoDisposeFutureProvider<List<VenueProfile>>.internal(
  myVenues,
  name: r'myVenuesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myVenuesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyVenuesRef = AutoDisposeFutureProviderRef<List<VenueProfile>>;
String _$updateVenueNotifierHash() =>
    r'10e71431c3dd0cecfa73904f92a90a2be661d218';

/// See also [UpdateVenueNotifier].
@ProviderFor(UpdateVenueNotifier)
final updateVenueNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UpdateVenueNotifier, void>.internal(
  UpdateVenueNotifier.new,
  name: r'updateVenueNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateVenueNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateVenueNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
