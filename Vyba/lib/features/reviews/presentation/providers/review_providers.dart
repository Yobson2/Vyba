import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/reviews/data/datasources/mock_review_datasource.dart';
import 'package:flutter_templates/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:flutter_templates/features/reviews/domain/entities/review.dart';
import 'package:flutter_templates/features/reviews/domain/repositories/review_repository.dart';
import 'package:flutter_templates/features/reviews/domain/usecases/submit_review_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_providers.g.dart';

// ---------------------------------------------------------------------------
// Data layer
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
MockReviewDatasource reviewDatasource(ReviewDatasourceRef ref) {
  return MockReviewDatasource();
}

@Riverpod(keepAlive: true)
ReviewRepository reviewRepository(ReviewRepositoryRef ref) {
  return ReviewRepositoryImpl(ref.watch(reviewDatasourceProvider));
}

// ---------------------------------------------------------------------------
// Use cases
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
SubmitReviewUseCase submitReviewUseCase(SubmitReviewUseCaseRef ref) {
  return SubmitReviewUseCase(ref.watch(reviewRepositoryProvider));
}

// ---------------------------------------------------------------------------
// Presentation state
// ---------------------------------------------------------------------------

@riverpod
Future<List<Review>> venueReviews(
  VenueReviewsRef ref,
  String venueId,
) async {
  final repo = ref.watch(reviewRepositoryProvider);
  final result = await repo.getVenueReviews(venueId);
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (List<Review> reviews) => reviews,
  );
}

@riverpod
class ReviewSubmitter extends _$ReviewSubmitter {
  @override
  FutureOr<Review?> build() => null;

  Future<void> submit({
    required String venueId,
    required double rating,
    required String text,
  }) async {
    state = const AsyncLoading<Review?>();
    final useCase = ref.read(submitReviewUseCaseProvider);
    final result = await useCase(
      SubmitReviewParams(venueId: venueId, rating: rating, text: text),
    );
    state = result.fold(
      (Failure failure) => AsyncError<Review?>(failure.message, StackTrace.current),
      (Review review) {
        // Invalidate the venue reviews cache so the list refreshes.
        ref.invalidate(venueReviewsProvider);
        return AsyncData<Review?>(review);
      },
    );
  }
}
