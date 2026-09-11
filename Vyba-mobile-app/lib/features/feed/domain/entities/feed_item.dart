import 'package:flutter/foundation.dart';

/// Polymorphic Zone 4 feed entry, mirroring the backend's `FeedItem` (spec
/// 03). Ticket 07 wired `live_tonight` and `editorial`; ticket 09 adds
/// `promo`. [UnknownFeedItem] is a forward-compatible fallback for types
/// this build doesn't know how to render yet (event, ...).
///
/// Renders in exactly the order the server returns (`items` list) — no
/// client-side re-sorting, ever (ADR-0001 / CONTEXT.md invariant).
@immutable
sealed class FeedItem {
  const FeedItem({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.startsAt,
    required this.expiresAt,
    required this.publishedAt,
  });

  final String id;
  final String? venueId;
  final String? venueName;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final DateTime publishedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => Object.hash(runtimeType, id);
}

/// A venue is live right now (ticket 06's "on est live ce soir").
@immutable
class LiveTonightFeedItem extends FeedItem {
  const LiveTonightFeedItem({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.startsAt,
    required super.expiresAt,
    required super.publishedAt,
  });
}

/// Team-authored editorial ("Ce soir à Zone 4", "5 spots chauds ce soir").
@immutable
class EditorialFeedItem extends FeedItem {
  const EditorialFeedItem({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.startsAt,
    required super.expiresAt,
    required super.publishedAt,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

/// An owner-created promotion (ticket 09) — title + description only, no
/// photo yet (ticket 14).
@immutable
class PromoFeedItem extends FeedItem {
  const PromoFeedItem({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.startsAt,
    required super.expiresAt,
    required super.publishedAt,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

/// A feed item of a type this build doesn't render yet (e.g. event — later
/// units). Kept so an unrecognised type never crashes the feed.
@immutable
class UnknownFeedItem extends FeedItem {
  const UnknownFeedItem({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.startsAt,
    required super.expiresAt,
    required super.publishedAt,
    required this.rawType,
  });

  final String rawType;
}
