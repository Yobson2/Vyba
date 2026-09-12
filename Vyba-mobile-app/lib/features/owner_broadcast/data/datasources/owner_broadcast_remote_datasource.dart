import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';

abstract class OwnerBroadcastRemoteDataSource {
  Future<void> sendBroadcast(
      {required String venueId, required String message});
}

class OwnerBroadcastRemoteDataSourceImpl
    implements OwnerBroadcastRemoteDataSource {
  const OwnerBroadcastRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> sendBroadcast({
    required String venueId,
    required String message,
  }) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.venueBroadcast.replaceAll('{venueId}', venueId),
        data: {'message': message},
      );
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
