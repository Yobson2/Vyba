import 'package:flutter_templates/features/follow/domain/entities/followed_venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';

/// Parses the backend's `FollowedVenueSummary` JSON directly into
/// [FollowedVenue] — a plain factory (not freezed) since it just maps a
/// small, flat shape and needs the same `venueType` string dispatch every
/// venue model in this app does.
class FollowedVenueModel {
  const FollowedVenueModel._();

  static FollowedVenue fromJson(Map<String, dynamic> json) {
    final venueTypeRaw = json['venueType'] as String? ?? '';
    return FollowedVenue(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      venueType: VenueType.values.firstWhere(
        (t) => t.name.toLowerCase() == venueTypeRaw.toLowerCase(),
        orElse: () => VenueType.bar,
      ),
      photos: (json['photos'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }
}
