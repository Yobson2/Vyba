import 'package:flutter_templates/features/reviews/domain/entities/review.dart';

/// Mock data source providing sample reviews for development.
class MockReviewDatasource {
  MockReviewDatasource()
      : _reviews = [
          Review(
            id: 'rev_1',
            userId: 'u1',
            userName: 'Tunde O.',
            userAvatar: 'https://i.pravatar.cc/150?img=12',
            venueId: 'v1',
            rating: 4.5,
            text:
                'Amazing rooftop views and great cocktails. The DJ set on '
                'Friday nights is unmatched. Will definitely come back!',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          Review(
            id: 'rev_2',
            userId: 'u2',
            userName: 'Amara K.',
            userAvatar: 'https://i.pravatar.cc/150?img=25',
            venueId: 'v1',
            rating: 5,
            text:
                'Best lounge in Lagos hands down. The VIP section is worth '
                'every naira. Staff were super attentive.',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
          Review(
            id: 'rev_3',
            userId: 'u3',
            userName: 'Chidi E.',
            userAvatar: 'https://i.pravatar.cc/150?img=33',
            venueId: 'v2',
            rating: 4,
            text:
                'Great ambiance and solid food menu. Gets crowded on weekends '
                'so book ahead. The jollof rice is a must-try.',
            createdAt: DateTime.now().subtract(const Duration(days: 7)),
          ),
          Review(
            id: 'rev_4',
            userId: 'u4',
            userName: 'Ngozi A.',
            userAvatar: 'https://i.pravatar.cc/150?img=44',
            venueId: 'v3',
            rating: 3.5,
            text:
                'Music was on point but drinks were a bit pricey. '
                'Good for special occasions though.',
            createdAt: DateTime.now().subtract(const Duration(days: 14)),
          ),
        ];

  final List<Review> _reviews;

  /// Returns reviews for the given [venueId].
  Future<List<Review>> getVenueReviews(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _reviews.where((r) => r.venueId == venueId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Adds a new review and returns it.
  Future<Review> submitReview({
    required String venueId,
    required double rating,
    required String text,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final review = Review(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      userName: 'You',
      userAvatar: 'https://i.pravatar.cc/150?img=8',
      venueId: venueId,
      rating: rating,
      text: text,
      createdAt: DateTime.now(),
    );
    _reviews.insert(0, review);
    return review;
  }
}
