import 'package:flutter/foundation.dart';

/// An active promotion for the venue-detail page's promo section (ticket
/// 09). Owner-created only in this build — `origin`/`assisted` provenance
/// is server-enforced and not surfaced to the client.
@immutable
class VenuePromo {
  const VenuePromo({
    required this.id,
    required this.title,
    required this.description,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime publishedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenuePromo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          publishedAt == other.publishedAt;

  @override
  int get hashCode => Object.hash(id, title, description, publishedAt);
}
