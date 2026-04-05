import 'package:flutter/foundation.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';

/// Filter criteria for venue search.
@immutable
class VenueFilter {
  const VenueFilter({
    this.query,
    this.venueTypes = const [],
    this.maxDistance,
    this.minRating,
    this.priceLevel,
    this.isOpenNow = false,
    this.hasPromo = false,
    this.hasVip = false,
    this.sortBy = VenueSortBy.relevance,
  });

  final String? query;
  final List<VenueType> venueTypes;
  final double? maxDistance;
  final double? minRating;
  final int? priceLevel;
  final bool isOpenNow;
  final bool hasPromo;
  final bool hasVip;
  final VenueSortBy sortBy;

  VenueFilter copyWith({
    String? query,
    List<VenueType>? venueTypes,
    double? maxDistance,
    double? minRating,
    int? priceLevel,
    bool? isOpenNow,
    bool? hasPromo,
    bool? hasVip,
    VenueSortBy? sortBy,
  }) {
    return VenueFilter(
      query: query ?? this.query,
      venueTypes: venueTypes ?? this.venueTypes,
      maxDistance: maxDistance ?? this.maxDistance,
      minRating: minRating ?? this.minRating,
      priceLevel: priceLevel ?? this.priceLevel,
      isOpenNow: isOpenNow ?? this.isOpenNow,
      hasPromo: hasPromo ?? this.hasPromo,
      hasVip: hasVip ?? this.hasVip,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

enum VenueSortBy { relevance, distance, rating, priceAsc, priceDesc }
