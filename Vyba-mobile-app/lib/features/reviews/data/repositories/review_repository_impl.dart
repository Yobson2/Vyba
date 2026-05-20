import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/reviews/data/datasources/mock_review_datasource.dart';
import 'package:flutter_templates/features/reviews/domain/entities/review.dart';
import 'package:flutter_templates/features/reviews/domain/repositories/review_repository.dart';

/// Implementation of [ReviewRepository] backed by [MockReviewDatasource].
class ReviewRepositoryImpl implements ReviewRepository {
  const ReviewRepositoryImpl(this._datasource);

  final MockReviewDatasource _datasource;

  @override
  Future<Either<Failure, Review>> submitReview({
    required String venueId,
    required double rating,
    required String text,
  }) async {
    try {
      final review = await _datasource.submitReview(
        venueId: venueId,
        rating: rating,
        text: text,
      );
      return Right(review);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Failed to submit review'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getVenueReviews(
    String venueId,
  ) async {
    try {
      final reviews = await _datasource.getVenueReviews(venueId);
      return Right(reviews);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Failed to load reviews'),
      );
    }
  }
}
