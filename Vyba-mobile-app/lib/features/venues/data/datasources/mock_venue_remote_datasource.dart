import 'package:flutter_templates/features/venues/data/datasources/venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/data/models/venue_model.dart';

/// Mock implementation with sample Abidjan venues.
class MockVenueRemoteDataSource implements VenueRemoteDataSource {
  static const _mockVenues = [
    VenueModel(
      id: '1',
      name: 'The Vibe Lounge',
      description:
          'Set in the heart of Victoria Island, The Vibe Lounge offers an unmatched nightlife experience with world-class DJs, an exquisite cocktail menu, and an exclusive atmosphere with indoor-outdoor seating.',
      address: 'Victoria Island, Abidjan',
      latitude: 6.4281,
      longitude: 3.4219,
      heroImages: [
        'https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=800',
        'https://images.unsplash.com/photo-1572116469696-31de0f17cc34?w=800',
      ],
      rating: 4.8,
      reviewCount: 342,
      isOpen: true,
      venueType: 'lounge',
      phone: '+225 01 23 45 67 89',
      priceLevel: 3,
      amenities: [
        'WiFi',
        'Parking',
        'Outdoor Deck',
        'Full Kitchen',
        'VIP Booths',
      ],
      isPremium: true,
      distance: 1.2,
      activePromoLabel: 'HAPPY HOUR',
    ),
    VenueModel(
      id: '2',
      name: 'Jazzhole Cocody',
      description:
          'A sophisticated jazz bar with live performances every weekend. Enjoy premium cocktails in an intimate setting with the best acoustic experience in Abidjan.',
      address: 'Cocody, Abidjan',
      latitude: 6.4541,
      longitude: 3.3947,
      heroImages: [
        'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
      ],
      rating: 4.5,
      reviewCount: 198,
      isOpen: true,
      venueType: 'bar',
      amenities: ['Live Music', 'Parking', 'Full Kitchen'],
      distance: 0.8,
    ),
    VenueModel(
      id: '3',
      name: 'Zaza Abidjan',
      description:
          'The premier VIP nightclub in Abidjan with state-of-the-art sound systems, exclusive bottle service, and the hottest DJs in West Africa.',
      address: 'Lekki Phase 1, Abidjan',
      latitude: 6.4350,
      longitude: 3.4700,
      heroImages: [
        'https://images.unsplash.com/photo-1571204829887-3b8d69e4094d?w=800',
        'https://images.unsplash.com/photo-1545128485-c400e7702712?w=800',
      ],
      rating: 4.9,
      reviewCount: 521,
      isOpen: false,
      venueType: 'club',
      phone: '+225 01 23 45 67 90',
      priceLevel: 4,
      amenities: ['VIP Booths', 'Parking', 'Full Bar', 'Dance Floor'],
      isPremium: true,
      distance: 3.5,
      activePromoLabel: 'VIP NIGHT',
    ),
    VenueModel(
      id: '4',
      name: 'Chez Tantie Maquis',
      description:
          'A classic Marcory maquis with grilled fish, attiéké, and live coupé-décalé on weekends. The go-to spot for a laid-back night out.',
      address: 'Zone 4, Marcory, Abidjan',
      latitude: 5.2925,
      longitude: -3.9836,
      heroImages: [
        'https://images.unsplash.com/photo-1555992336-03a23c7b20ee?w=800',
      ],
      rating: 4.4,
      reviewCount: 87,
      isOpen: true,
      venueType: 'maquis',
      priceLevel: 1,
      amenities: ['Outdoor Seating', 'Live Music', 'Grilled Fish'],
      distance: 0.5,
    ),
  ];

  @override
  Future<List<VenueModel>> getVenues({
    Map<String, dynamic>? queryParams,
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _mockVenues;
  }

  @override
  Future<VenueModel> getVenueById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _mockVenues.firstWhere((v) => v.id == id);
  }

  @override
  Future<List<VenueModel>> searchVenues(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final q = query.toLowerCase();
    return _mockVenues
        .where(
          (v) =>
              v.name.toLowerCase().contains(q) ||
              v.address.toLowerCase().contains(q) ||
              v.venueType.toLowerCase().contains(q),
        )
        .toList();
  }
}
