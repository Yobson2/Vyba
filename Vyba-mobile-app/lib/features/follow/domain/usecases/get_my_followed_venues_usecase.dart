import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/follow/domain/entities/followed_venue.dart';
import 'package:flutter_templates/features/follow/domain/repositories/follow_repository.dart';

class GetMyFollowedVenuesUseCase
    extends UseCase<List<FollowedVenue>, NoParams> {
  const GetMyFollowedVenuesUseCase(this._repository);

  final FollowRepository _repository;

  @override
  Future<Either<Failure, List<FollowedVenue>>> call(NoParams params) {
    return _repository.getMyFollowedVenues();
  }
}
