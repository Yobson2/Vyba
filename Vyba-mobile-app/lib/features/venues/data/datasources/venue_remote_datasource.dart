import 'package:flutter_templates/features/venues/data/models/venue_menu_model.dart';
import 'package:flutter_templates/features/venues/data/models/venue_model.dart';

/// Abstract venue remote data source.
abstract class VenueRemoteDataSource {
  Future<List<VenueModel>> getVenues({
    Map<String, dynamic>? queryParams,
    int page = 1,
    int limit = 20,
  });

  Future<VenueModel> getVenueById(String id);

  Future<VenueMenuModel> getVenueMenu(String venueId);

  Future<List<VenueModel>> searchVenues(String query);
}
