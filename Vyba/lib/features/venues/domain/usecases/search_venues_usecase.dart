import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:flutter_templates/features/venues/domain/repositories/venue_repository.dart';

class SearchVenuesUseCase extends UseCase<List<Venue>, String> {
  SearchVenuesUseCase(this._repository);

  final VenueRepository _repository;

  @override
  Future<Either<Failure, List<Venue>>> call(String params) {
    return _repository.searchVenues(params);
  }
}
