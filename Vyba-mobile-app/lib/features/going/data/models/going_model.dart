import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'going_model.freezed.dart';
part 'going_model.g.dart';

/// Matches the backend `Going` response. Extra fields (userId, venueNightId,
/// canceledAt, timestamps) are ignored by json_serializable.
@freezed
abstract class GoingModel with _$GoingModel {
  const GoingModel._();

  const factory GoingModel({
    required String id,
    required String venueId,
    @Default(1) int partySize,
    @Default(false) bool identityPublic,
  }) = _GoingModel;

  factory GoingModel.fromJson(Map<String, dynamic> json) =>
      _$GoingModelFromJson(json);

  Going toEntity() => Going(
        id: id,
        venueId: venueId,
        partySize: partySize,
        identityPublic: identityPublic,
      );
}
