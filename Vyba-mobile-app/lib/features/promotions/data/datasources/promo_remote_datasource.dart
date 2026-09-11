import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/promotions/data/models/promo_model.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promo.dart';

abstract class PromoRemoteDataSource {
  Future<Promo> createPromo({
    required String venueId,
    required String title,
    required String description,
  });
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  const PromoRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Promo> createPromo({
    required String venueId,
    required String title,
    required String description,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.venuePromoCreate.replaceAll('{venueId}', venueId),
        data: {'title': title, 'description': description},
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException(message: 'Réponse vide du serveur');
      }
      return PromoModel.fromJson(data);
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
