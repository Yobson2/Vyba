import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/venue_night/domain/entities/owner_venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';

/// Owner-side actions on tonight's state for their bound venue (ticket 06).
abstract class VenueNightRepository {
  /// The venue bound to the signed-in owner.
  Future<Either<Failure, OwnerVenue>> getMyVenue();

  /// Current tonight state for [venueId] (works before the venue is ACTIVE).
  Future<Either<Failure, VenueTonight>> getTonight(String venueId);

  /// Idempotent: setting the same live state twice is a no-op server-side.
  Future<Either<Failure, VenueTonight>> setLive({
    required String venueId,
    required bool isLive,
  });

  Future<Either<Failure, VenueTonight>> setHeadline({
    required String venueId,
    String? headline,
    String? djName,
  });
}
