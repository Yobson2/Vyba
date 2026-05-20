import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/reviews/domain/entities/review.dart';

/// Abstract contract for review-related data operations.
abstract class ReviewRepository {
  /// Submits a new review for a venue.
  Future<Either<Failure, Review>> submitReview({
    required String venueId,
    required double rating,
    required String text,
  });

  /// Returns all reviews for the given [venueId].
  Future<Either<Failure, List<Review>>> getVenueReviews(String venueId);
}
