// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_promo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VenuePromoModel _$VenuePromoModelFromJson(Map<String, dynamic> json) =>
    _VenuePromoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$VenuePromoModelToJson(_VenuePromoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };
