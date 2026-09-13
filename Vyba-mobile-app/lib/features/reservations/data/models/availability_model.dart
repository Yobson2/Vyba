import 'package:flutter_templates/features/reservations/domain/entities/availability.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'availability_model.freezed.dart';
part 'availability_model.g.dart';

@freezed
abstract class AvailabilityModel with _$AvailabilityModel {
  const AvailabilityModel._();

  const factory AvailabilityModel({
    @Default(false) bool reservationsEnabled,
    int? confirmedReservationsCount,
  }) = _AvailabilityModel;

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);

  Availability toEntity() => Availability(
        reservationsEnabled: reservationsEnabled,
        confirmedReservationsCount: confirmedReservationsCount,
      );
}
