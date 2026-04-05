import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/favorites/domain/repositories/favorite_repository.dart';

/// Toggles the favorite state for a venue.
///
/// Returns `true` if the venue is now favorited, `false` if removed.
class ToggleFavoriteUseCase extends UseCase<bool, String> {
  const ToggleFavoriteUseCase(this._repository);

  final FavoriteRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.toggleFavorite(params);
  }
}
