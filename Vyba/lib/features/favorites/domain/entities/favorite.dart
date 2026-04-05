import 'package:flutter/foundation.dart';

/// Domain entity representing a favorited venue.
@immutable
class Favorite {
  const Favorite({
    required this.id,
    required this.venueId,
    required this.name,
    required this.image,
    required this.rating,
    required this.address,
    required this.favoritedAt,
  });

  /// Unique identifier for the favorite entry.
  final String id;

  /// The venue's identifier.
  final String venueId;

  /// Venue display name.
  final String name;

  /// Hero image URL or asset path.
  final String image;

  /// Venue star rating (0.0 – 5.0).
  final double rating;

  /// Human-readable venue address.
  final String address;

  /// Timestamp when the venue was favorited.
  final DateTime favoritedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Favorite &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
