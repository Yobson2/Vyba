import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/venue_management/domain/entities/venue_profile.dart';

abstract class VenueManagementRepository {
  Future<Either<Failure, List<VenueProfile>>> getMyVenues();
  Future<Either<Failure, VenueProfile>> updateVenueProfile(
    VenueProfile venue,
  );
}
