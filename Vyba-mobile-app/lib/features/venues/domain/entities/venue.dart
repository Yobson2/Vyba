import 'package:flutter/foundation.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_promo.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';

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
    this.priceLevel = 2,
    this.amenities = const [],
    this.isPremium = false,
    this.distance,
    this.activePromoLabel,
    this.inLaunchArea = true,
    this.tonight,
    this.promos = const [],
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

  /// Legacy "open now" flag from the template. Superseded by
  /// `tonight?.isLive` wherever tonight data is available (spec 02: the
  /// live signal replaces "open now" — see `Venue.isLiveTonight`).
  final bool isOpen;
  final VenueType venueType;
  final String? phone;
  final int priceLevel;
  final List<String> amenities;
  final bool isPremium;
  final double? distance;
  final String? activePromoLabel;
  final bool inLaunchArea;

  /// Tonight's state (ticket 06). `null` = "rien d'annoncé ce soir".
  final VenueTonight? tonight;

  /// Active promotions for this venue's page (ticket 09).
  final List<VenuePromo> promos;

  /// The live signal to actually render — prefers `tonight`, falls back to
  /// the legacy `isOpen` flag for venues fetched without tonight data.
  bool get isLiveTonight => tonight?.isLive ?? isOpen;

  String get firstImage => heroImages.isNotEmpty ? heroImages.first : '';

  String get formattedDistance {
    if (distance == null) return '';
    if (distance! < 1) return '${(distance! * 1000).round()}m away';
    return '${distance!.toStringAsFixed(1)} km away';
  }

  /// Price level shown as repeated FCFA markers (e.g. "FCFA FCFA").
  String get priceLevelLabel => List.filled(priceLevel, 'FCFA').join(' ');
}

/// Venue categories in the validation launch market (Zone 4 / Marcory).
enum VenueType {
  club,
  bar,
  lounge,
  maquis,
}
