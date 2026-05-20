// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteDatasourceHash() =>
    r'61bd1be913dcd603079ebe3223bee70279d716ef';

/// See also [favoriteDatasource].
@ProviderFor(favoriteDatasource)
final favoriteDatasourceProvider = Provider<MockFavoriteDatasource>.internal(
  favoriteDatasource,
  name: r'favoriteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteDatasourceRef = ProviderRef<MockFavoriteDatasource>;
String _$favoriteRepositoryHash() =>
    r'3fa6536ff0a81936f0862f9823e66a5b91ca57fb';

/// See also [favoriteRepository].
@ProviderFor(favoriteRepository)
final favoriteRepositoryProvider = Provider<FavoriteRepository>.internal(
  favoriteRepository,
  name: r'favoriteRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteRepositoryRef = ProviderRef<FavoriteRepository>;
String _$getFavoritesUseCaseHash() =>
    r'e984fa73f1220f3f869b9fc56eb8ae4dbe8925ef';

/// See also [getFavoritesUseCase].
@ProviderFor(getFavoritesUseCase)
final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>.internal(
  getFavoritesUseCase,
  name: r'getFavoritesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFavoritesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFavoritesUseCaseRef = ProviderRef<GetFavoritesUseCase>;
String _$toggleFavoriteUseCaseHash() =>
    r'c564f82fb4f114f985f469e68b7b4eaf69808615';

/// See also [toggleFavoriteUseCase].
@ProviderFor(toggleFavoriteUseCase)
final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>.internal(
  toggleFavoriteUseCase,
  name: r'toggleFavoriteUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$toggleFavoriteUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ToggleFavoriteUseCaseRef = ProviderRef<ToggleFavoriteUseCase>;
String _$favoritesHash() => r'f73255f3752771411246fadd16ae215057a1c456';

/// See also [favorites].
@ProviderFor(favorites)
final favoritesProvider = AutoDisposeFutureProvider<List<Favorite>>.internal(
  favorites,
  name: r'favoritesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$favoritesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoritesRef = AutoDisposeFutureProviderRef<List<Favorite>>;
String _$favoriteToggleHash() => r'e3abaf3b33237bc628b37c05667996aeb1a3ee01';

/// See also [FavoriteToggle].
@ProviderFor(FavoriteToggle)
final favoriteToggleProvider =
    AutoDisposeAsyncNotifierProvider<FavoriteToggle, void>.internal(
  FavoriteToggle.new,
  name: r'favoriteToggleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteToggleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FavoriteToggle = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
