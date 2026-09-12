import 'package:flutter/foundation.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';

/// A venue on "mes lieux avec notifications" (ticket 17) — deliberately
/// separate from `FollowedVenue`: opting in is not the same choice as
/// following.
@immutable
class OptedInVenue {
  const OptedInVenue({
    required this.id,
    required this.name,
    required this.venueType,
  });

  final String id;
  final String name;
  final VenueType venueType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptedInVenue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          venueType == other.venueType;

  @override
  int get hashCode => Object.hash(id, name, venueType);
}
