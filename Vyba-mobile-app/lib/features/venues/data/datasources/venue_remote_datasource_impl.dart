import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/venues/data/datasources/venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/data/models/venue_model.dart';

/// Real implementation of [VenueRemoteDataSource].
///
/// [getVenues]/[searchVenues] hit `GET /api/discover/venues` (ADR-0005): not
/// geofenced, optional text `query`, optional `lat`/`lng`/`radiusKm` for
/// nearby sorting. That endpoint's response is camelCase (this backend's
/// normal convention), unlike [VenueModel.fromJson] which expects the mock
/// datasource's snake_case shape — so results are mapped into [VenueModel]
/// field-by-field here instead of through `fromJson`.
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
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.venuesDiscover,
        queryParameters: {...?queryParams, 'page': page, 'limit': limit},
      );
      final rows = response.data?['data'] as List<dynamic>? ?? [];
      return rows
          .cast<Map<String, dynamic>>()
          .map(_discoverySummaryToModel)
          .toList();
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<List<VenueModel>> searchVenues(String query) {
    return getVenues(queryParams: {'query': query});
  }

  /// Maps `GET /api/discover/venues`' `VenueDiscoverySummary` (camelCase,
  /// `distanceKm`) into [VenueModel] — fields the summary doesn't carry
  /// (description, rating, promos, ...) fall back to their model defaults.
  VenueModel _discoverySummaryToModel(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      heroImages: (json['photos'] as List<dynamic>?)?.cast<String>() ?? [],
      venueType: (json['venueType'] as String?) ?? 'BAR',
      priceLevel: (json['priceLevel'] as num?)?.toInt() ?? 1,
      distance: (json['distanceKm'] as num?)?.toDouble(),
    );
  }

  Never _throwMapped(DioException e) {
    final wrapped = e.error;
    if (wrapped is Exception) throw wrapped;
    throw ServerException(message: e.message ?? 'Erreur réseau');
  }
}
