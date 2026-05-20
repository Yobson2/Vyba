import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_model.freezed.dart';
part 'venue_model.g.dart';

@freezed
abstract class VenueModel with _$VenueModel {
  const VenueModel._();

  const factory VenueModel({
    required String id,
    required String name,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'hero_images') required List<String> heroImages,
    required double rating,
    @JsonKey(name: 'review_count') required int reviewCount,
    @JsonKey(name: 'is_open') required bool isOpen,
    @JsonKey(name: 'venue_type') required String venueType,
    String? phone,
    @JsonKey(name: 'opening_hours') String? openingHours,
    @JsonKey(name: 'price_level') @Default(2) int priceLevel,
    @Default([]) List<String> amenities,
    @JsonKey(name: 'is_premium') @Default(false) bool isPremium,
    @JsonKey(name: 'has_vip_pass') @Default(false) bool hasVipPass,
    double? distance,
    @JsonKey(name: 'active_promo_label') String? activePromoLabel,
  }) = _VenueModel;

  factory VenueModel.fromJson(Map<String, dynamic> json) =>
      _$VenueModelFromJson(json);

  Venue toEntity() => Venue(
        id: id,
        name: name,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        heroImages: heroImages,
        rating: rating,
        reviewCount: reviewCount,
        isOpen: isOpen,
        venueType: VenueType.values.firstWhere(
          (t) => t.name == venueType,
          orElse: () => VenueType.bar,
        ),
        phone: phone,
        openingHours: openingHours,
        priceLevel: priceLevel,
        amenities: amenities,
        isPremium: isPremium,
        hasVipPass: hasVipPass,
        distance: distance,
        activePromoLabel: activePromoLabel,
      );
}
