import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:flutter_templates/features/venues/data/models/venue_promo_model.dart';
import 'package:flutter_templates/features/venues/data/models/venue_tonight_model.dart';
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
    @JsonKey(name: 'photos') required List<String> heroImages,
    @Default(0) double rating,
    @Default(0) @JsonKey(name: 'review_count') int reviewCount,
    @Default(false) @JsonKey(name: 'is_open') bool isOpen,
    @JsonKey(name: 'venue_type') required String venueType,
    String? phone,
    @JsonKey(name: 'price_level') @Default(2) int priceLevel,
    @Default([]) List<String> amenities,
    @JsonKey(name: 'is_premium') @Default(false) bool isPremium,
    double? distance,
    @JsonKey(name: 'active_promo_label') String? activePromoLabel,
    @Default(true) bool inLaunchArea,
    VenueTonightModel? tonight,
    @Default([]) List<VenuePromoModel> promos,
    @Default(0) int followerCount,
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
          (t) => t.name.toLowerCase() == venueType.toLowerCase(),
          orElse: () => VenueType.bar,
        ),
        phone: phone,
        priceLevel: priceLevel,
        amenities: amenities,
        isPremium: isPremium,
        distance: distance,
        activePromoLabel: activePromoLabel,
        inLaunchArea: inLaunchArea,
        tonight: tonight?.toEntity(),
        promos: promos.map((p) => p.toEntity()).toList(),
        followerCount: followerCount,
      );
}
