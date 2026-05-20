import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/promotions/data/datasources/mock_promotion_datasource.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promotion.dart';
import 'package:flutter_templates/features/promotions/domain/repositories/promotion_repository.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  PromotionRepositoryImpl(this._dataSource);

  final PromotionDataSource _dataSource;

  @override
  Future<Either<Failure, Promotion>> createPromotion({
    required String title,
    required String description,
    required String imageUrl,
    required PromoType promoType,
    required DateTime startDate,
    required DateTime endDate,
    required String venueId,
    bool isPremiumBoosted = false,
  }) async {
    try {
      final promo = await _dataSource.createPromotion(
        title: title,
        description: description,
        imageUrl: imageUrl,
        promoType: promoType,
        startDate: startDate,
        endDate: endDate,
        venueId: venueId,
        isPremiumBoosted: isPremiumBoosted,
      );
      return Right(promo);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Promotion>>> getMyPromotions() async {
    try {
      final promos = await _dataSource.getMyPromotions();
      return Right(promos);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
