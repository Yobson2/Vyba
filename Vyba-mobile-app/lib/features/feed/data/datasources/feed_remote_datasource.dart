import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';

/// Raw feed JSON — kept as `Map`s (not parsed to entities) so the repository
/// can cache the exact server response for offline replay.
abstract class FeedRemoteDataSource {
  Future<List<Map<String, dynamic>>> getFeed({
    required int limit,
    required int offset,
  });
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  const FeedRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Map<String, dynamic>>> getFeed({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.feedRanked,
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = response.data ?? [];
      return data.cast<Map<String, dynamic>>();
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
