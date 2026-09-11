import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';

/// Parses the backend's `FeedItem` JSON directly into the matching sealed
/// [FeedItem] subtype — payload shape is type-dependent, so a single
/// dispatching factory is simpler than a parallel Model-per-type hierarchy.
class FeedItemModel {
  const FeedItemModel._();

  static FeedItem fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final venueJson = json['venue'] as Map<String, dynamic>?;
    final venueId = venueJson?['id'] as String?;
    final venueName = venueJson?['name'] as String?;
    final startsAt = _parseDate(json['startsAt']);
    final expiresAt = _parseDate(json['expiresAt']);
    final publishedAt = _parseDate(json['publishedAt']) ?? DateTime.now();
    final payload = json['payload'] as Map<String, dynamic>?;

    switch (json['type'] as String?) {
      case 'LIVE_TONIGHT':
        return LiveTonightFeedItem(
          id: id,
          venueId: venueId,
          venueName: venueName,
          startsAt: startsAt,
          expiresAt: expiresAt,
          publishedAt: publishedAt,
        );
      case 'PROMO':
        return PromoFeedItem(
          id: id,
          venueId: venueId,
          venueName: venueName,
          startsAt: startsAt,
          expiresAt: expiresAt,
          publishedAt: publishedAt,
          title: payload?['title'] as String? ?? '',
          description: payload?['description'] as String? ?? '',
        );
      case 'EDITORIAL':
        return EditorialFeedItem(
          id: id,
          venueId: venueId,
          venueName: venueName,
          startsAt: startsAt,
          expiresAt: expiresAt,
          publishedAt: publishedAt,
          title: payload?['title'] as String? ?? '',
          body: payload?['body'] as String? ?? '',
        );
      default:
        return UnknownFeedItem(
          id: id,
          venueId: venueId,
          venueName: venueName,
          startsAt: startsAt,
          expiresAt: expiresAt,
          publishedAt: publishedAt,
          rawType: json['type'] as String? ?? 'unknown',
        );
    }
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }
}
