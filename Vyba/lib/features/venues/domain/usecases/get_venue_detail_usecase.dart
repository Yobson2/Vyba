import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:flutter_templates/features/venues/domain/repositories/venue_repository.dart';

class GetVenueDetailUseCase extends UseCase<Venue, String> {
  GetVenueDetailUseCase(this._repository);

  final VenueRepository _repository;

  @override
  Future<Either<Failure, Venue>> call(String params) {
    return _repository.getVenueById(params);
  }
}
