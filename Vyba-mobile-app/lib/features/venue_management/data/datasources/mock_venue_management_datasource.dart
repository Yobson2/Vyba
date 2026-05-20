import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/features/venue_management/domain/entities/venue_profile.dart';

abstract class VenueManagementDataSource {
  Future<List<VenueProfile>> getMyVenues();
  Future<VenueProfile> updateVenueProfile(VenueProfile venue);
}

class MockVenueManagementDataSource implements VenueManagementDataSource {
  final List<VenueProfile> _venues = [
    const VenueProfile(
      id: 'v-001',
      name: 'The Vibe Lounge',
      description:
          'Lagos premier nightlife destination with world-class DJs, '
          'craft cocktails, and an electric atmosphere.',
      address: '23 Admiralty Way, Lekki Phase 1, Lagos',
      phone: '+234 801 234 5678',
      openingHours: {
        'Mon-Thu': '5:00 PM - 2:00 AM',
        'Fri-Sat': '5:00 PM - 4:00 AM',
        'Sun': '4:00 PM - 12:00 AM',
      },
      amenities: [
        'VIP Booths',
        'Outdoor Terrace',
        'Live DJ',
        'Hookah',
        'Parking',
        'Bottle Service',
      ],
      images: [
        'https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=800',
        'https://images.unsplash.com/photo-1571204829887-3b8d69e4094d?w=800',
        'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
      ],
      priceLevel: 3,
      rating: 4.7,
      totalBookings: 342,
    ),
    const VenueProfile(
      id: 'v-002',
      name: 'Velvet Rooftop',
      description:
          'An elegant rooftop bar offering panoramic views of the Lagos '
          'skyline, signature cocktails, and live acoustic performances.',
      address: '15 Victoria Island Road, Victoria Island, Lagos',
      phone: '+234 802 345 6789',
      openingHours: {
        'Mon-Thu': '6:00 PM - 1:00 AM',
        'Fri-Sat': '6:00 PM - 3:00 AM',
        'Sun': 'Closed',
      },
      amenities: [
        'Rooftop Views',
        'Live Music',
        'Cocktail Bar',
        'Private Events',
        'WiFi',
      ],
      images: [
        'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800',
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      ],
      priceLevel: 4,
      rating: 4.5,
      totalBookings: 187,
    ),
  ];

  @override
  Future<List<VenueProfile>> getMyVenues() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_venues);
  }

  @override
  Future<VenueProfile> updateVenueProfile(VenueProfile venue) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final index = _venues.indexWhere((v) => v.id == venue.id);
    if (index == -1) {
      throw const ServerException(message: 'Venue not found');
    }
    _venues[index] = venue;
    return venue;
  }
}
