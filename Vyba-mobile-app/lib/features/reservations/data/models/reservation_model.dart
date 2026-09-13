import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation_model.freezed.dart';
part 'reservation_model.g.dart';

/// Matches the backend `Reservation` response (camelCase). Extra fields
/// (userId, venueNightId, timestamps, respondedBy) are ignored.
@freezed
abstract class ReservationModel with _$ReservationModel {
  const ReservationModel._();

  const factory ReservationModel({
    required String id,
    required String venueId,
    @Default(1) int partySize,
    String? note,
    @Default('PENDING') String status,
  }) = _ReservationModel;

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);

  Reservation toEntity() => Reservation(
        id: id,
        venueId: venueId,
        partySize: partySize,
        note: note,
        status: ReservationStatus.values.firstWhere(
          (s) => s.name.toLowerCase() == status.toLowerCase(),
          orElse: () => ReservationStatus.pending,
        ),
      );
}
