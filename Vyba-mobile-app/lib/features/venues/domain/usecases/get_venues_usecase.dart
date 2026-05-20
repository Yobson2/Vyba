import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_filter.dart';
import 'package:flutter_templates/features/venues/domain/repositories/venue_repository.dart';

class GetVenuesUseCase extends UseCase<List<Venue>, GetVenuesParams> {
  GetVenuesUseCase(this._repository);

  final VenueRepository _repository;

  @override
  Future<Either<Failure, List<Venue>>> call(GetVenuesParams params) {
    return _repository.getVenues(
      filter: params.filter,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetVenuesParams {
  const GetVenuesParams({this.filter, this.page = 1, this.limit = 20});

  final VenueFilter? filter;
  final int page;
  final int limit;
}
