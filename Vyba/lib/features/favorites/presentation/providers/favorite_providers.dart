import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/favorites/data/datasources/mock_favorite_datasource.dart';
import 'package:flutter_templates/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:flutter_templates/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_templates/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:flutter_templates/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:flutter_templates/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_providers.g.dart';

// ---------------------------------------------------------------------------
// Data layer
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
MockFavoriteDatasource favoriteDatasource(FavoriteDatasourceRef ref) {
  return MockFavoriteDatasource();
}

@Riverpod(keepAlive: true)
FavoriteRepository favoriteRepository(FavoriteRepositoryRef ref) {
  return FavoriteRepositoryImpl(ref.watch(favoriteDatasourceProvider));
}

// ---------------------------------------------------------------------------
// Use cases
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
GetFavoritesUseCase getFavoritesUseCase(GetFavoritesUseCaseRef ref) {
  return GetFavoritesUseCase(ref.watch(favoriteRepositoryProvider));
}

@Riverpod(keepAlive: true)
ToggleFavoriteUseCase toggleFavoriteUseCase(ToggleFavoriteUseCaseRef ref) {
  return ToggleFavoriteUseCase(ref.watch(favoriteRepositoryProvider));
}

// ---------------------------------------------------------------------------
// Presentation state
// ---------------------------------------------------------------------------

@riverpod
Future<List<Favorite>> favorites(FavoritesRef ref) async {
  final useCase = ref.watch(getFavoritesUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (List<Favorite> favorites) => favorites,
  );
}

@riverpod
class FavoriteToggle extends _$FavoriteToggle {
  @override
  FutureOr<void> build() {}

  Future<void> toggle(String venueId) async {
    state = const AsyncLoading<void>();
    final useCase = ref.read(toggleFavoriteUseCaseProvider);
    final result = await useCase(venueId);
    state = result.fold(
      (Failure failure) => AsyncError<void>(failure.message, StackTrace.current),
      (_) {
        ref.invalidate(favoritesProvider);
        return const AsyncData<void>(null);
      },
    );
  }
}
