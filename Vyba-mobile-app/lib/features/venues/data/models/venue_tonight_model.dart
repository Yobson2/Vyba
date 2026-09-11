import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_tonight_model.freezed.dart';
part 'venue_tonight_model.g.dart';

/// Data model for [VenueTonight], matching the backend's `VenueTonight` /
/// `VenueNight` response shape (`isLive`, `liveSince`, `headline`, `djName`,
/// `goingCount`) — the extra fields on a full `VenueNight` entity response
/// (id, venueId, date, ...) are ignored by json_serializable by default.
@freezed
abstract class VenueTonightModel with _$VenueTonightModel {
  const VenueTonightModel._();

  const factory VenueTonightModel({
    required bool isLive,
    DateTime? liveSince,
    String? headline,
    String? djName,
    @Default(0) int goingCount,
  }) = _VenueTonightModel;

  factory VenueTonightModel.fromJson(Map<String, dynamic> json) =>
      _$VenueTonightModelFromJson(json);

  VenueTonight toEntity() => VenueTonight(
        isLive: isLive,
        liveSince: liveSince,
        headline: headline,
        djName: djName,
        goingCount: goingCount,
      );
}
