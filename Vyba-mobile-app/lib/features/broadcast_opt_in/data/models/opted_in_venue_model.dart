import 'package:flutter_templates/features/broadcast_opt_in/domain/entities/opted_in_venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';

/// A plain factory (not freezed) — mirrors `FollowedVenueModel`'s reasoning:
/// a small, flat shape mapped straight from the backend JSON.
class OptedInVenueModel {
  const OptedInVenueModel._();

  static OptedInVenue fromJson(Map<String, dynamic> json) {
    final venueTypeRaw = json['venueType'] as String? ?? '';
    return OptedInVenue(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      venueType: VenueType.values.firstWhere(
        (t) => t.name.toLowerCase() == venueTypeRaw.toLowerCase(),
        orElse: () => VenueType.bar,
      ),
    );
  }
}
