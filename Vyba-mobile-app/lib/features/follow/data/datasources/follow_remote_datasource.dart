import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/follow/data/models/followed_venue_model.dart';
import 'package:flutter_templates/features/follow/domain/entities/followed_venue.dart';

abstract class FollowRemoteDataSource {
  Future<bool> isFollowing(String venueId);
  Future<void> follow(String venueId);
  Future<void> unfollow(String venueId);
  Future<List<FollowedVenue>> getMyFollowedVenues();
}

class FollowRemoteDataSourceImpl implements FollowRemoteDataSource {
  const FollowRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<bool> isFollowing(String venueId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.followMine.replaceAll('{venueId}', venueId),
      );
      return (response.data?['isFollowing'] as bool?) ?? false;
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<void> follow(String venueId) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.followByVenue.replaceAll('{venueId}', venueId),
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<void> unfollow(String venueId) async {
    try {
      await _dio.delete<void>(
        ApiEndpoints.followByVenue.replaceAll('{venueId}', venueId),
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<List<FollowedVenue>> getMyFollowedVenues() async {
    try {
      final response =
          await _dio.get<List<dynamic>>(ApiEndpoints.followedVenues);
      final data = response.data ?? const [];
      return data
          .map((e) => FollowedVenueModel.fromJson(e as Map<String, dynamic>))
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
