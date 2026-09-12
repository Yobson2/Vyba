import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/media/data/models/venue_night_photo_model.dart';
import 'package:flutter_templates/features/media/domain/entities/venue_night_photo.dart';

abstract class MediaRemoteDataSource {
  Future<VenueNightPhoto> uploadVenueNightPhoto({
    required String venueId,
    required String filePath,
  });

  Future<List<VenueNightPhoto>> getVenueNightPhotos(String venueId);
}

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  const MediaRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<VenueNightPhoto> uploadVenueNightPhoto({
    required String venueId,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'venueId': venueId,
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.mediaVenueNightPhoto,
        data: formData,
      );
      return VenueNightPhotoModel.fromJson(response.data!);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<List<VenueNightPhoto>> getVenueNightPhotos(String venueId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.mediaVenueNightPhotos.replaceAll('{venueId}', venueId),
      );
      final data = response.data ?? const [];
      return data
          .map(
            (e) => VenueNightPhotoModel.fromJson(e as Map<String, dynamic>),
          )
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
