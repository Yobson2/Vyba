// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) =>
    _ReservationModel(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      partySize: (json['partySize'] as num?)?.toInt() ?? 1,
      note: json['note'] as String?,
      status: json['status'] as String? ?? 'PENDING',
    );

Map<String, dynamic> _$ReservationModelToJson(_ReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueId': instance.venueId,
      'partySize': instance.partySize,
      'note': instance.note,
      'status': instance.status,
    };
