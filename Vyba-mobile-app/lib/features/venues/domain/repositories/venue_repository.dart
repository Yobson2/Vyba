import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_filter.dart';

/// Abstract venue repository interface.
abstract class VenueRepository {
  Future<Either<Failure, List<Venue>>> getVenues({
    VenueFilter? filter,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, Venue>> getVenueById(String id);

  Future<Either<Failure, List<Venue>>> searchVenues(String query);
}
