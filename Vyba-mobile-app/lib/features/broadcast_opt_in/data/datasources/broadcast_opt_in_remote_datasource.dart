import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/broadcast_opt_in/data/models/opted_in_venue_model.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/entities/opted_in_venue.dart';

abstract class BroadcastOptInRemoteDataSource {
  Future<bool> isOptedIn(String venueId);
  Future<void> optIn(String venueId);
  Future<void> optOut(String venueId);
  Future<List<OptedInVenue>> getMyOptIns();
}

class BroadcastOptInRemoteDataSourceImpl
    implements BroadcastOptInRemoteDataSource {
  const BroadcastOptInRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<bool> isOptedIn(String venueId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.broadcastOptIn.replaceAll('{venueId}', venueId),
      );
      return (response.data?['optedIn'] as bool?) ?? false;
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<void> optIn(String venueId) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.broadcastOptIn.replaceAll('{venueId}', venueId),
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<void> optOut(String venueId) async {
    try {
      await _dio.delete<void>(
        ApiEndpoints.broadcastOptIn.replaceAll('{venueId}', venueId),
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<List<OptedInVenue>> getMyOptIns() async {
    try {
      final response =
          await _dio.get<List<dynamic>>(ApiEndpoints.broadcastOptIns);
      final data = response.data ?? const [];
      return data
          .map((e) => OptedInVenueModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  Never _throwMapped(DioException e) {
    final wrapped = e.error;
    if (wrapped is Exception) throw wrapped;
    throw ServerException(message: e.message ?? 'Erreur réseau');
  }
}
