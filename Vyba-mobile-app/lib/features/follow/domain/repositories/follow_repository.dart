import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/follow/domain/entities/followed_venue.dart';

abstract class FollowRepository {
  Future<Either<Failure, bool>> isFollowing(String venueId);
  Future<Either<Failure, void>> follow(String venueId);
  Future<Either<Failure, void>> unfollow(String venueId);
  Future<Either<Failure, List<FollowedVenue>>> getMyFollowedVenues();
}
