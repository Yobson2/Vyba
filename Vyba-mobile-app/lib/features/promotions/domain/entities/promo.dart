import 'package:flutter/foundation.dart';

/// A venue-created promotion (ticket 09) — title + description only, no
/// photo yet (ticket 14) and no explicit date field: always today-scoped,
/// mirroring the backend's `PROMO` feed item.
@immutable
class Promo {
  const Promo({
    required this.id,
    required this.venueId,
    required this.title,
    required this.description,
    required this.publishedAt,
  });

  final String id;
  final String venueId;
  final String title;
  final String description;
  final DateTime publishedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Promo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          venueId == other.venueId &&
          title == other.title &&
          description == other.description &&
          publishedAt == other.publishedAt;

  @override
  int get hashCode =>
      Object.hash(id, venueId, title, description, publishedAt);
}
