import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/venues/data/datasources/venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/data/models/venue_model.dart';

/// Real implementation of [VenueRemoteDataSource].
///
/// Only [getVenueById] is wired to the real backend today (venue detail,
/// ticket 06) — the public venue *list* endpoint for Explore doesn't exist
/// on the backend yet (a later ticket), so [getVenues]/[searchVenues] are
/// intentionally unimplemented here. Explore keeps using
/// [MockVenueRemoteDataSource] via its own provider; only the venue-detail
/// provider chain is wired to this class.
class VenueRemoteDataSourceImpl implements VenueRemoteDataSource {
  const VenueRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<VenueModel> getVenueById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.venueDetailWithTonight.replaceAll('{id}', id),
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException(message: 'Réponse vide du serveur');
      }
      return VenueModel.fromJson(data);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<List<VenueModel>> getVenues({
    Map<String, dynamic>? queryParams,
    int page = 1,
    int limit = 20,
  }) {
    throw UnimplementedError(
      'Public venue list endpoint is not built yet (Explore uses the mock datasource).',
    );
  }

  @override
  Future<List<VenueModel>> searchVenues(String query) {
    throw UnimplementedError(
      'Venue search endpoint is not built yet (Explore uses the mock datasource).',
    );
  }

  Never _throwMapped(DioException e) {
    final wrapped = e.error;
    if (wrapped is Exception) throw wrapped;
    throw ServerException(message: e.message ?? 'Erreur réseau');
  }
}
