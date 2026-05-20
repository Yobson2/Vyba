import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/reviews/domain/entities/review.dart';
import 'package:flutter_templates/features/reviews/domain/repositories/review_repository.dart';

/// Submits a new review for a venue.
class SubmitReviewUseCase extends UseCase<Review, SubmitReviewParams> {
  const SubmitReviewUseCase(this._repository);

  final ReviewRepository _repository;

  @override
  Future<Either<Failure, Review>> call(SubmitReviewParams params) {
    return _repository.submitReview(
      venueId: params.venueId,
      rating: params.rating,
      text: params.text,
    );
  }
}

/// Parameters for [SubmitReviewUseCase].
@immutable
class SubmitReviewParams {
  const SubmitReviewParams({
    required this.venueId,
    required this.rating,
    required this.text,
  });

  final String venueId;
  final double rating;
  final String text;
}
