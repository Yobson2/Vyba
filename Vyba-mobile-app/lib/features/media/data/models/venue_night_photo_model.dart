import 'package:flutter_templates/features/media/domain/entities/venue_night_photo.dart';

/// A plain factory (not freezed) — mirrors `FollowedVenueModel`'s reasoning:
/// a small, flat shape mapped straight from the `MediaAsset` JSON.
class VenueNightPhotoModel {
  const VenueNightPhotoModel._();

  static VenueNightPhoto fromJson(Map<String, dynamic> json) {
    return VenueNightPhoto(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String? ?? json['url'] as String,
    );
  }
}
