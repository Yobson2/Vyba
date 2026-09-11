// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'going_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoingModel _$GoingModelFromJson(Map<String, dynamic> json) => _GoingModel(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      partySize: (json['partySize'] as num?)?.toInt() ?? 1,
      identityPublic: json['identityPublic'] as bool? ?? false,
    );

Map<String, dynamic> _$GoingModelToJson(_GoingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueId': instance.venueId,
      'partySize': instance.partySize,
      'identityPublic': instance.identityPublic,
    };
