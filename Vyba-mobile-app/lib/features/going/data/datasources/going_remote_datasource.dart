import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/going/data/models/going_model.dart';
import 'package:flutter_templates/features/going/data/models/owner_going_summary_model.dart';

abstract class GoingRemoteDataSource {
  Future<GoingModel?> getMine(String venueId);
  Future<GoingModel> mark({
    required String venueId,
    int? partySize,
    bool? identityPublic,
  });
  Future<GoingModel> update({
    required String venueId,
    int? partySize,
    bool? identityPublic,
  });
  Future<void> cancel(String venueId);
  Future<OwnerGoingSummaryModel> getOwnerSummary(String venueId);
}

class GoingRemoteDataSourceImpl implements GoingRemoteDataSource {
  const GoingRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<GoingModel?> getMine(String venueId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>?>(
        ApiEndpoints.goingMine.replaceAll('{venueId}', venueId),
      );
      final data = response.data;
      return data == null ? null : GoingModel.fromJson(data);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<GoingModel> mark({
    required String venueId,
    int? partySize,
    bool? identityPublic,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.goingMark,
        data: {
          'venueId': venueId,
          if (partySize != null) 'partySize': partySize,
          if (identityPublic != null) 'identityPublic': identityPublic,
        },
      );
      return GoingModel.fromJson(_dataOrThrow(response.data));
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<GoingModel> update({
    required String venueId,
    int? partySize,
    bool? identityPublic,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.goingByVenue.replaceAll('{venueId}', venueId),
        data: {
          if (partySize != null) 'partySize': partySize,
          if (identityPublic != null) 'identityPublic': identityPublic,
        },
      );
      return GoingModel.fromJson(_dataOrThrow(response.data));
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<void> cancel(String venueId) async {
    try {
      await _dio.delete<void>(
        ApiEndpoints.goingByVenue.replaceAll('{venueId}', venueId),
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<OwnerGoingSummaryModel> getOwnerSummary(String venueId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.goingOwnerSummary.replaceAll('{venueId}', venueId),
      );
      return OwnerGoingSummaryModel.fromJson(_dataOrThrow(response.data));
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
