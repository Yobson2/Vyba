import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/reservations/data/models/availability_model.dart';
import 'package:flutter_templates/features/reservations/data/models/reservation_model.dart';

abstract class ReservationRemoteDataSource {
  Future<ReservationModel?> getMine(String venueId);
  Future<ReservationModel> create({
    required String venueId,
    int? partySize,
    String? note,
  });
  Future<void> cancel(String venueId);
  Future<AvailabilityModel> getAvailability(String venueId);
  Future<List<ReservationModel>> listForOwner(String venueId);
  Future<ReservationModel> respond({
    required String reservationId,
    required bool confirm,
  });
}

class ReservationRemoteDataSourceImpl implements ReservationRemoteDataSource {
  const ReservationRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ReservationModel?> getMine(String venueId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>?>(
        ApiEndpoints.reservationMine.replaceAll('{venueId}', venueId),
      );
      final data = response.data;
      return data == null ? null : ReservationModel.fromJson(data);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<ReservationModel> create({
    required String venueId,
    int? partySize,
    String? note,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.reservationCreate,
        data: {
          'venueId': venueId,
          if (partySize != null) 'partySize': partySize,
          if (note != null) 'note': note,
        },
      );
      return ReservationModel.fromJson(_dataOrThrow(response.data));
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<void> cancel(String venueId) async {
    try {
      await _dio.delete<void>(
        ApiEndpoints.reservationByVenue.replaceAll('{venueId}', venueId),
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<AvailabilityModel> getAvailability(String venueId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.reservationAvailability.replaceAll('{venueId}', venueId),
      );
      return AvailabilityModel.fromJson(_dataOrThrow(response.data));
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<List<ReservationModel>> listForOwner(String venueId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.reservationOwnerList.replaceAll('{venueId}', venueId),
      );
      final rows = response.data ?? [];
      return rows
          .cast<Map<String, dynamic>>()
          .map(ReservationModel.fromJson)
          .toList();
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<ReservationModel> respond({
    required String reservationId,
    required bool confirm,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.reservationRespond.replaceAll('{id}', reservationId),
        data: {'status': confirm ? 'CONFIRMED' : 'REJECTED'},
      );
      return ReservationModel.fromJson(_dataOrThrow(response.data));
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
