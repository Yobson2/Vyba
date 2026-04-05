// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VenueModel _$VenueModelFromJson(Map<String, dynamic> json) => _VenueModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      heroImages: (json['hero_images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
      isOpen: json['is_open'] as bool,
      venueType: json['venue_type'] as String,
      phone: json['phone'] as String?,
      openingHours: json['opening_hours'] as String?,
      priceLevel: (json['price_level'] as num?)?.toInt() ?? 2,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isPremium: json['is_premium'] as bool? ?? false,
      hasVipPass: json['has_vip_pass'] as bool? ?? false,
      distance: (json['distance'] as num?)?.toDouble(),
      activePromoLabel: json['active_promo_label'] as String?,
    );

Map<String, dynamic> _$VenueModelToJson(_VenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'hero_images': instance.heroImages,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'is_open': instance.isOpen,
      'venue_type': instance.venueType,
      'phone': instance.phone,
      'opening_hours': instance.openingHours,
      'price_level': instance.priceLevel,
      'amenities': instance.amenities,
      'is_premium': instance.isPremium,
      'has_vip_pass': instance.hasVipPass,
      'distance': instance.distance,
      'active_promo_label': instance.activePromoLabel,
    };
