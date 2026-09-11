import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/venue_night/data/models/owner_venue_model.dart';
import 'package:flutter_templates/features/venues/data/models/venue_tonight_model.dart';

/// Owner night-actions remote data source (ticket 06).
abstract class VenueNightRemoteDataSource {
  Future<OwnerVenueModel> getMyVenue();
  Future<VenueTonightModel> getTonight(String venueId);
  Future<VenueTonightModel> setLive({
    required String venueId,
    required bool isLive,
  });
  Future<VenueTonightModel> setHeadline({
    required String venueId,
    String? headline,
    String? djName,
  });
}

class VenueNightRemoteDataSourceImpl implements VenueNightRemoteDataSource {
  const VenueNightRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<OwnerVenueModel> getMyVenue() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.ownerMyVenue,
      );
      return OwnerVenueModel.fromJson(_dataOrThrow(response.data));
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<VenueTonightModel> getTonight(String venueId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.venueTonight.replaceAll('{id}', venueId),
      );
      return VenueTonightModel.fromJson(_dataOrThrow(response.data));
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<VenueTonightModel> setLive({
    required String venueId,
    required bool isLive,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.venueLive.replaceAll('{id}', venueId),
        data: {'isLive': isLive},
      );
      return VenueTonightModel.fromJson(_dataOrThrow(response.data));
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<VenueTonightModel> setHeadline({
    required String venueId,
    String? headline,
    String? djName,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.venueTonight.replaceAll('{id}', venueId),
        data: {
          if (headline != null) 'headline': headline,
          if (djName != null) 'djName': djName,
        },
      );
      return VenueTonightModel.fromJson(_dataOrThrow(response.data));
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  Map<String, dynamic> _dataOrThrow(Map<String, dynamic>? data) {
    if (data == null) {
      throw const ServerException(message: 'Réponse vide du serveur');
    }
    return data;
  }

  Never _throwMapped(DioException e) {
    final wrapped = e.error;
    if (wrapped is Exception) throw wrapped;
    throw ServerException(message: e.message ?? 'Erreur réseau');
  }
}
