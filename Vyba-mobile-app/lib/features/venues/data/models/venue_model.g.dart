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
      heroImages:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      isOpen: json['is_open'] as bool? ?? false,
      venueType: json['venue_type'] as String,
      phone: json['phone'] as String?,
      priceLevel: (json['price_level'] as num?)?.toInt() ?? 2,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isPremium: json['is_premium'] as bool? ?? false,
      distance: (json['distance'] as num?)?.toDouble(),
      activePromoLabel: json['active_promo_label'] as String?,
      inLaunchArea: json['inLaunchArea'] as bool? ?? true,
      tonight: json['tonight'] == null
          ? null
          : VenueTonightModel.fromJson(json['tonight'] as Map<String, dynamic>),
      promos: (json['promos'] as List<dynamic>?)
              ?.map((e) => VenuePromoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
      capacity: (json['capacity'] as num?)?.toInt(),
      reservationsEnabled: json['reservationsEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$VenueModelToJson(_VenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'photos': instance.heroImages,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'is_open': instance.isOpen,
      'venue_type': instance.venueType,
      'phone': instance.phone,
      'price_level': instance.priceLevel,
      'amenities': instance.amenities,
      'is_premium': instance.isPremium,
      'distance': instance.distance,
      'active_promo_label': instance.activePromoLabel,
      'inLaunchArea': instance.inLaunchArea,
      'tonight': instance.tonight,
      'promos': instance.promos,
      'followerCount': instance.followerCount,
      'capacity': instance.capacity,
      'reservationsEnabled': instance.reservationsEnabled,
    };
