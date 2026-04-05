import 'package:flutter/foundation.dart';

/// Domain entity representing a venue.
@immutable
class Venue {
  const Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.heroImages,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.venueType,
    this.phone,
    this.openingHours,
    this.priceLevel = 2,
    this.amenities = const [],
    this.isPremium = false,
    this.hasVipPass = false,
    this.distance,
    this.activePromoLabel,
  });

  final String id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> heroImages;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final VenueType venueType;
  final String? phone;
  final String? openingHours;
  final int priceLevel;
  final List<String> amenities;
  final bool isPremium;
  final bool hasVipPass;
  final double? distance;
  final String? activePromoLabel;

  String get firstImage =>
      heroImages.isNotEmpty ? heroImages.first : '';

  String get formattedDistance {
    if (distance == null) return '';
    if (distance! < 1) return '${(distance! * 1000).round()}m away';
    return '${distance!.toStringAsFixed(1)} km away';
  }

  String get priceLevelLabel => List.filled(priceLevel, '₦').join();
}

enum VenueType {
  club,
  bar,
  lounge,
  restaurant,
  rooftop,
  beachClub,
  maquis,
}
