import 'package:flutter_templates/features/favorites/domain/entities/favorite.dart';

/// Mock data source providing sample favorites for development.
class MockFavoriteDatasource {
  MockFavoriteDatasource()
      : _favorites = {
          'v1': Favorite(
            id: 'fav_1',
            venueId: 'v1',
            name: 'Sky Lounge Abidjan',
            image: 'https://images.unsplash.com/photo-1566417713940-fe7c737a9ef2?w=800',
            rating: 4.8,
            address: 'Victoria Island, Abidjan',
            favoritedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          'v2': Favorite(
            id: 'fav_2',
            venueId: 'v2',
            name: 'Lagoon Restaurant',
            image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
            rating: 4.5,
            address: 'Ozumba Mbadiwe Ave, VI',
            favoritedAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          'v3': Favorite(
            id: 'fav_3',
            venueId: 'v3',
            name: 'Quilox Nightclub',
            image: 'https://images.unsplash.com/photo-1519214605650-76a613ee3245?w=800',
            rating: 4.6,
            address: 'Ozumba Mbadiwe, VI',
            favoritedAt: DateTime.now().subtract(const Duration(hours: 12)),
          ),
        };

  final Map<String, Favorite> _favorites;

  /// Returns all current favorites.
  Future<List<Favorite>> getFavorites() async {
    // Simulate network latency.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _favorites.values.toList()
      ..sort((a, b) => b.favoritedAt.compareTo(a.favoritedAt));
  }

  /// Toggles the favorite state for [venueId].
  ///
  /// Returns `true` if added, `false` if removed.
  Future<bool> toggleFavorite(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (_favorites.containsKey(venueId)) {
      _favorites.remove(venueId);
      return false;
    }
    _favorites[venueId] = Favorite(
      id: 'fav_${DateTime.now().millisecondsSinceEpoch}',
      venueId: venueId,
      name: 'Venue $venueId',
      image: 'https://images.unsplash.com/photo-1566417713940-fe7c737a9ef2?w=800',
      rating: 4,
      address: 'Abidjan, Nigeria',
      favoritedAt: DateTime.now(),
    );
    return true;
  }

  /// Checks whether [venueId] is in the favorites map.
  Future<bool> isFavorite(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _favorites.containsKey(venueId);
  }
}
