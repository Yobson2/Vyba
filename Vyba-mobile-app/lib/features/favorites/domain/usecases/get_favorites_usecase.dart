import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_templates/features/favorites/domain/repositories/favorite_repository.dart';

/// Retrieves the current user's list of favorited venues.
class GetFavoritesUseCase extends UseCase<List<Favorite>, NoParams> {
  const GetFavoritesUseCase(this._repository);

  final FavoriteRepository _repository;

  @override
  Future<Either<Failure, List<Favorite>>> call(NoParams params) {
    return _repository.getFavorites();
  }
}
