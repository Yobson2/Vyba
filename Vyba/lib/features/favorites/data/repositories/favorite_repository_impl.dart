import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/favorites/data/datasources/mock_favorite_datasource.dart';
import 'package:flutter_templates/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_templates/features/favorites/domain/repositories/favorite_repository.dart';

/// Implementation of [FavoriteRepository] backed by [MockFavoriteDatasource].
class FavoriteRepositoryImpl implements FavoriteRepository {
  const FavoriteRepositoryImpl(this._datasource);

  final MockFavoriteDatasource _datasource;

  @override
  Future<Either<Failure, List<Favorite>>> getFavorites() async {
    try {
      final favorites = await _datasource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return const Left(
        CacheFailure(message: 'Failed to load favorites'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String venueId) async {
    try {
      final result = await _datasource.toggleFavorite(venueId);
      return Right(result);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Failed to toggle favorite'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String venueId) async {
    try {
      final result = await _datasource.isFavorite(venueId);
      return Right(result);
    } catch (e) {
      return const Left(
        CacheFailure(message: 'Failed to check favorite status'),
      );
    }
  }
}
