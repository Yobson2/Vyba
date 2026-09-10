import 'package:flutter_templates/features/venues/data/datasources/venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/data/models/venue_menu_model.dart';
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
      phone: '+234 801 234 5678',
      openingHours: 'Open until 4 AM',
      priceLevel: 3,
      amenities: ['WiFi', 'Parking', 'Outdoor Deck', 'Full Kitchen', 'VIP Booths'],
      isPremium: true,
      hasVipPass: true,
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
      openingHours: 'Closing at 3 PM',
      priceLevel: 2,
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
      phone: '+234 802 345 6789',
      openingHours: 'Opens at 10 PM',
      priceLevel: 4,
      amenities: ['VIP Booths', 'Parking', 'Full Bar', 'Dance Floor'],
      isPremium: true,
      hasVipPass: true,
      distance: 3.5,
      activePromoLabel: 'VIP NIGHT',
    ),
    VenueModel(
      id: '4',
      name: 'Moist Beach Club',
      description:
          'Beachfront dining and entertainment with ocean views. Perfect for sunset cocktails and late-night dancing under the stars.',
      address: 'Oniru Beach, Abidjan',
      latitude: 6.4200,
      longitude: 3.4400,
      heroImages: [
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      ],
      rating: 4.3,
      reviewCount: 156,
      isOpen: true,
      venueType: 'beachClub',
      openingHours: 'Open until 2 AM',
      priceLevel: 3,
      amenities: ['Beach Access', 'Outdoor Seating', 'Full Kitchen', 'Parking'],
      distance: 2.1,
    ),
    VenueModel(
      id: '5',
      name: 'Velvet Rooftop',
      description:
          'Elevated dining and lounge experience with panoramic city views. The rooftop features a curated cocktail menu and weekend DJ sets.',
      address: 'Ikoyi, Abidjan',
      latitude: 6.4500,
      longitude: 3.4300,
      heroImages: [
        'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800',
      ],
      rating: 4.6,
      reviewCount: 234,
      isOpen: true,
      venueType: 'rooftop',
      openingHours: 'Open until 1 AM',
      priceLevel: 3,
      amenities: ['Rooftop Views', 'Full Bar', 'Lounge Seating'],
      distance: 1.8,
      activePromoLabel: '20% OFF',
    ),
    VenueModel(
      id: '6',
      name: 'Shiro Restaurant',
      description:
          'Award-winning Pan-Asian restaurant with a vibrant bar scene. Known for exquisite sushi and premium sake selection.',
      address: 'Victoria Island, Abidjan',
      latitude: 6.4310,
      longitude: 3.4250,
      heroImages: [
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      ],
      rating: 4.7,
      reviewCount: 412,
      isOpen: true,
      venueType: 'restaurant',
      openingHours: 'Open until midnight',
      priceLevel: 4,
      amenities: ['WiFi', 'Parking', 'Full Kitchen', 'Private Dining'],
      isPremium: true,
      distance: 1.5,
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
  Future<VenueMenuModel> getVenueMenu(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const VenueMenuModel(
      categories: [
        MenuCategoryModel(name: 'Cocktails', items: [
          MenuItemModel(id: 'm1', name: 'Abidjan Sunset', price: 5500, description: 'Rum, mango, passion fruit, lime'),
          MenuItemModel(id: 'm2', name: 'Neon Negroni', price: 6000, description: 'Gin, Campari, sweet vermouth'),
          MenuItemModel(id: 'm3', name: 'Palm Wine Spritz', price: 4500, description: 'Palm wine, prosecco, elderflower'),
        ]),
        MenuCategoryModel(name: 'Small Plates', items: [
          MenuItemModel(id: 'm4', name: 'Suya Skewers', price: 3500, description: 'Spiced beef skewers with yaji'),
          MenuItemModel(id: 'm5', name: 'Plantain Chips & Guac', price: 2800),
          MenuItemModel(id: 'm6', name: 'Grilled Prawns', price: 7500, description: 'Tiger prawns, chili butter, lime'),
        ]),
        MenuCategoryModel(name: 'Mains', items: [
          MenuItemModel(id: 'm7', name: 'Jollof Risotto', price: 8500, description: 'Smoky jollof-spiced arborio rice'),
          MenuItemModel(id: 'm8', name: 'Grilled Sea Bass', price: 12000),
        ]),
        MenuCategoryModel(name: 'Bottles', items: [
          MenuItemModel(id: 'm9', name: 'Moët & Chandon', price: 85000),
          MenuItemModel(id: 'm10', name: 'Hennessy VS', price: 65000),
          MenuItemModel(id: 'm11', name: 'Dom Pérignon', price: 250000),
        ]),
      ],
    );
  }

  @override
  Future<List<VenueModel>> searchVenues(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final q = query.toLowerCase();
    return _mockVenues
        .where((v) =>
            v.name.toLowerCase().contains(q) ||
            v.address.toLowerCase().contains(q) ||
            v.venueType.toLowerCase().contains(q))
        .toList();
  }
}
