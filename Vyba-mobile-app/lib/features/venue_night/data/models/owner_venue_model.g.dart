// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerVenueModel _$OwnerVenueModelFromJson(Map<String, dynamic> json) =>
    _OwnerVenueModel(
      id: json['id'] as String,
      name: json['name'] as String,
      reservationsEnabled: json['reservationsEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$OwnerVenueModelToJson(_OwnerVenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reservationsEnabled': instance.reservationsEnabled,
    };
