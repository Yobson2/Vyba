import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/favorites/domain/entities/favorite.dart';

/// Abstract contract for favorite-related data operations.
abstract class FavoriteRepository {
  /// Returns all favorited venues.
  Future<Either<Failure, List<Favorite>>> getFavorites();

  /// Toggles the favorite state for the given [venueId].
  ///
  /// Returns `true` if the venue is now favorited, `false` if removed.
  Future<Either<Failure, bool>> toggleFavorite(String venueId);

  /// Checks whether the given [venueId] is currently favorited.
  Future<Either<Failure, bool>> isFavorite(String venueId);
}
