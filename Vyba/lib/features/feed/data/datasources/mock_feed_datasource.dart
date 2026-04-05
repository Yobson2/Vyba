import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';

/// Abstract interface for feed data source.
abstract class FeedDataSource {
  Future<List<FeedItem>> getFeed({int page = 1});
  Future<void> markInterested(String eventId);
}

/// Mock implementation with sample Lagos feed items.
class MockFeedDataSource implements FeedDataSource {
  final Set<String> _interestedEventIds = {};

  @override
  Future<List<FeedItem>> getFeed({int page = 1}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return [
      PromoFeedItem(
        id: 'promo-001',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        title: 'Happy Hour — 50% Off Cocktails',
        description:
            'Enjoy half-price cocktails every Friday from 6 PM to 9 PM. '
            'Lagos Sunset, Neon Negroni, and more.',
        imageUrl:
            'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=800',
        venueName: 'The Vibe Lounge',
        validUntil: DateTime.now().add(const Duration(days: 3)),
        promoType: 'discount',
      ),
      EventFeedItem(
        id: 'event-001',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        title: 'Afrobeats Takeover Night',
        imageUrl:
            'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
        venueName: 'Zaza Lagos',
        date: DateTime.now().add(const Duration(days: 7)),
        attendeeCount: 234,
        attendeeAvatars: [
          'https://i.pravatar.cc/150?img=1',
          'https://i.pravatar.cc/150?img=2',
          'https://i.pravatar.cc/150?img=3',
        ],
        isInterested: _interestedEventIds.contains('event-001'),
      ),
      PromoFeedItem(
        id: 'promo-002',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        title: 'VIP Table — Free Bottle Service',
        description:
            'Book a VIP booth this weekend and get a complimentary bottle '
            'of Moet. Limited availability.',
        imageUrl:
            'https://images.unsplash.com/photo-1571204829887-3b8d69e4094d?w=800',
        venueName: 'Velvet Rooftop',
        validUntil: DateTime.now().add(const Duration(days: 2)),
        promoType: 'vip',
      ),
      EventFeedItem(
        id: 'event-002',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        title: 'Sunset Jazz Sessions',
        imageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
        venueName: 'Moist Beach Club',
        date: DateTime.now().add(const Duration(days: 3)),
        attendeeCount: 89,
        attendeeAvatars: [
          'https://i.pravatar.cc/150?img=4',
          'https://i.pravatar.cc/150?img=5',
        ],
        isInterested: _interestedEventIds.contains('event-002'),
      ),
      EventFeedItem(
        id: 'event-003',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        title: 'Rooftop Silent Disco',
        imageUrl:
            'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800',
        venueName: 'Velvet Rooftop',
        date: DateTime.now().add(const Duration(days: 10)),
        attendeeCount: 156,
        attendeeAvatars: [
          'https://i.pravatar.cc/150?img=6',
          'https://i.pravatar.cc/150?img=7',
          'https://i.pravatar.cc/150?img=8',
        ],
        isInterested: _interestedEventIds.contains('event-003'),
      ),
    ];
  }

  @override
  Future<void> markInterested(String eventId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (_interestedEventIds.contains(eventId)) {
      _interestedEventIds.remove(eventId);
    } else {
      _interestedEventIds.add(eventId);
    }
  }
}
