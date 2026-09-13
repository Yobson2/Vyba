// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$venueRemoteDataSourceHash() =>
    r'83b806d7249b93d32adf2dbc492944eb1e40167b';

/// Backs the Explore listing — `GET /api/discover/venues` (ADR-0005): text
/// search and/or geolocated "nearby" sorting, not geofenced.
///
/// Copied from [venueRemoteDataSource].
@ProviderFor(venueRemoteDataSource)
final venueRemoteDataSourceProvider = Provider<VenueRemoteDataSource>.internal(
  venueRemoteDataSource,
  name: r'venueRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venueRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VenueRemoteDataSourceRef = ProviderRef<VenueRemoteDataSource>;
String _$venueRepositoryHash() => r'8db7766ff09863e5475e60058b5d818ff2261d9b';

/// See also [venueRepository].
@ProviderFor(venueRepository)
final venueRepositoryProvider = Provider<VenueRepository>.internal(
  venueRepository,
  name: r'venueRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venueRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VenueRepositoryRef = ProviderRef<VenueRepository>;
String _$getVenuesUseCaseHash() => r'9e14c74f9c66ff070970b3a0064d92892109362e';

/// See also [getVenuesUseCase].
@ProviderFor(getVenuesUseCase)
final getVenuesUseCaseProvider = AutoDisposeProvider<GetVenuesUseCase>.internal(
  getVenuesUseCase,
  name: r'getVenuesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getVenuesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetVenuesUseCaseRef = AutoDisposeProviderRef<GetVenuesUseCase>;
String _$searchVenuesUseCaseHash() =>
    r'53b841c5b9de31ad742a3fbec739d3425079ad42';

/// See also [searchVenuesUseCase].
@ProviderFor(searchVenuesUseCase)
final searchVenuesUseCaseProvider =
    AutoDisposeProvider<SearchVenuesUseCase>.internal(
  searchVenuesUseCase,
  name: r'searchVenuesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchVenuesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchVenuesUseCaseRef = AutoDisposeProviderRef<SearchVenuesUseCase>;
String _$venueDetailRemoteDataSourceHash() =>
    r'1bebd9e763133d6108a92913f80e3c80bd7387e1';

/// Backs venue *detail* (ticket 06) — real backend, distinct from the
/// mock-backed listing provider above.
///
/// Copied from [venueDetailRemoteDataSource].
@ProviderFor(venueDetailRemoteDataSource)
final venueDetailRemoteDataSourceProvider =
    Provider<VenueRemoteDataSource>.internal(
  venueDetailRemoteDataSource,
  name: r'venueDetailRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venueDetailRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VenueDetailRemoteDataSourceRef = ProviderRef<VenueRemoteDataSource>;
String _$venueDetailRepositoryHash() =>
    r'db7ada39793585cc191c25874c70bae8ba409218';

/// See also [venueDetailRepository].
@ProviderFor(venueDetailRepository)
final venueDetailRepositoryProvider = Provider<VenueRepository>.internal(
  venueDetailRepository,
  name: r'venueDetailRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venueDetailRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VenueDetailRepositoryRef = ProviderRef<VenueRepository>;
String _$getVenueDetailUseCaseHash() =>
    r'2b564a1393c331e243dc245ce2ab64caec4dc46c';

/// See also [getVenueDetailUseCase].
@ProviderFor(getVenueDetailUseCase)
final getVenueDetailUseCaseProvider =
    AutoDisposeProvider<GetVenueDetailUseCase>.internal(
  getVenueDetailUseCase,
  name: r'getVenueDetailUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getVenueDetailUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetVenueDetailUseCaseRef
    = AutoDisposeProviderRef<GetVenueDetailUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
