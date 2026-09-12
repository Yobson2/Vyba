import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/follow/domain/repositories/follow_repository.dart';

class IsFollowingUseCase extends UseCase<bool, String> {
  const IsFollowingUseCase(this._repository);

  final FollowRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String venueId) {
    return _repository.isFollowing(venueId);
  }
}
