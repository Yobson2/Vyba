import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/entities/owner_venue.dart';
import 'package:flutter_templates/features/venue_night/domain/repositories/venue_night_repository.dart';

class GetMyVenueUseCase extends UseCase<OwnerVenue, NoParams> {
  const GetMyVenueUseCase(this._repository);

  final VenueNightRepository _repository;

  @override
  Future<Either<Failure, OwnerVenue>> call(NoParams params) {
    return _repository.getMyVenue();
  }
}
