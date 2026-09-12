import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/entities/opted_in_venue.dart';

abstract class BroadcastOptInRepository {
  Future<Either<Failure, bool>> isOptedIn(String venueId);
  Future<Either<Failure, void>> optIn(String venueId);
  Future<Either<Failure, void>> optOut(String venueId);
  Future<Either<Failure, List<OptedInVenue>>> getMyOptIns();
}
