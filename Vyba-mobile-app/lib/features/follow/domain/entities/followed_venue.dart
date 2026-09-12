import 'package:flutter/foundation.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';

/// A venue on the client's "mes lieux suivis" list (ticket 10) — enough
/// detail to render the list, not the full venue-detail payload.
@immutable
class FollowedVenue {
  const FollowedVenue({
    required this.id,
    required this.name,
    required this.venueType,
    required this.photos,
  });

  final String id;
  final String name;
  final VenueType venueType;
  final List<String> photos;

  String get firstPhoto => photos.isNotEmpty ? photos.first : '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowedVenue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          venueType == other.venueType &&
          listEquals(photos, other.photos);

  @override
  int get hashCode => Object.hash(id, name, venueType, Object.hashAll(photos));
}
