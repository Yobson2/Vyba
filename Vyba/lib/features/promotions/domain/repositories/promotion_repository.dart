import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promotion.dart';

abstract class PromotionRepository {
  Future<Either<Failure, Promotion>> createPromotion({
    required String title,
    required String description,
    required String imageUrl,
    required PromoType promoType,
    required DateTime startDate,
    required DateTime endDate,
    required String venueId,
    bool isPremiumBoosted,
  });
  Future<Either<Failure, List<Promotion>>> getMyPromotions();
}
