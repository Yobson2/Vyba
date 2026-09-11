import 'package:flutter_templates/features/venue_night/domain/entities/owner_venue.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_venue_model.freezed.dart';
part 'owner_venue_model.g.dart';

/// Matches `GET /api/owner/venue`. Extra fields on the response (address,
/// photos, ...) are ignored by json_serializable.
@freezed
abstract class OwnerVenueModel with _$OwnerVenueModel {
  const OwnerVenueModel._();

  const factory OwnerVenueModel({
    required String id,
    required String name,
  }) = _OwnerVenueModel;

  factory OwnerVenueModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerVenueModelFromJson(json);

  OwnerVenue toEntity() => OwnerVenue(id: id, name: name);
}
