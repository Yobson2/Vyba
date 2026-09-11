// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_tonight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VenueTonightModel _$VenueTonightModelFromJson(Map<String, dynamic> json) =>
    _VenueTonightModel(
      isLive: json['isLive'] as bool,
      liveSince: json['liveSince'] == null
          ? null
          : DateTime.parse(json['liveSince'] as String),
      headline: json['headline'] as String?,
      djName: json['djName'] as String?,
      goingCount: (json['goingCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VenueTonightModelToJson(_VenueTonightModel instance) =>
    <String, dynamic>{
      'isLive': instance.isLive,
      'liveSince': instance.liveSince?.toIso8601String(),
      'headline': instance.headline,
      'djName': instance.djName,
      'goingCount': instance.goingCount,
    };
