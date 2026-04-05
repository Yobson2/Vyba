import 'package:flutter/foundation.dart';

@immutable
class VenueProfile {
  const VenueProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.openingHours,
    required this.amenities,
    required this.images,
    required this.priceLevel,
    this.rating = 0,
    this.totalBookings = 0,
  });

  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final Map<String, String> openingHours;
  final List<String> amenities;
  final List<String> images;
  final int priceLevel;
  final double rating;
  final int totalBookings;

  VenueProfile copyWith({
    String? name,
    String? description,
    String? address,
    String? phone,
    Map<String, String>? openingHours,
    List<String>? amenities,
    List<String>? images,
    int? priceLevel,
    double? rating,
    int? totalBookings,
  }) {
    return VenueProfile(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      openingHours: openingHours ?? this.openingHours,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      priceLevel: priceLevel ?? this.priceLevel,
      rating: rating ?? this.rating,
      totalBookings: totalBookings ?? this.totalBookings,
    );
  }
}
