import 'package:flutter/foundation.dart';

/// Domain entity representing a user review for a venue.
@immutable
class Review {
  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.venueId,
    required this.rating,
    required this.text,
    required this.createdAt,
  });

  /// Unique review identifier.
  final String id;

  /// Author's user identifier.
  final String userId;

  /// Author's display name.
  final String userName;

  /// Author's avatar URL or asset path.
  final String userAvatar;

  /// The venue being reviewed.
  final String venueId;

  /// Star rating (0.0 – 5.0).
  final double rating;

  /// Review body text.
  final String text;

  /// Timestamp when the review was submitted.
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Review && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
