// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AvailabilityModel _$AvailabilityModelFromJson(Map<String, dynamic> json) =>
    _AvailabilityModel(
      reservationsEnabled: json['reservationsEnabled'] as bool? ?? false,
      confirmedReservationsCount:
          (json['confirmedReservationsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AvailabilityModelToJson(_AvailabilityModel instance) =>
    <String, dynamic>{
      'reservationsEnabled': instance.reservationsEnabled,
      'confirmedReservationsCount': instance.confirmedReservationsCount,
    };
