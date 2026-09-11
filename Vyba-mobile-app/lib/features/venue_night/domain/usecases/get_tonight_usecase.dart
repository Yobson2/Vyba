import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/repositories/venue_night_repository.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';

class GetTonightUseCase extends UseCase<VenueTonight, String> {
  const GetTonightUseCase(this._repository);

  final VenueNightRepository _repository;

  @override
  Future<Either<Failure, VenueTonight>> call(String venueId) {
    return _repository.getTonight(venueId);
  }
}
