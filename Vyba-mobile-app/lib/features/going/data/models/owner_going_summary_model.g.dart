// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_going_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerGoingSummaryModel _$OwnerGoingSummaryModelFromJson(
        Map<String, dynamic> json) =>
    _OwnerGoingSummaryModel(
      count: (json['count'] as num?)?.toInt() ?? 0,
      partySizes: (json['partySizes'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OwnerGoingSummaryModelToJson(
        _OwnerGoingSummaryModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'partySizes': instance.partySizes,
    };
