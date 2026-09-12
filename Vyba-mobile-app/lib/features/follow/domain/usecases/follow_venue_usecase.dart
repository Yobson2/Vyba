import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/follow/domain/repositories/follow_repository.dart';

class FollowVenueUseCase extends UseCase<void, String> {
  const FollowVenueUseCase(this._repository);

  final FollowRepository _repository;

  @override
  Future<Either<Failure, void>> call(String venueId) {
    return _repository.follow(venueId);
  }
}
