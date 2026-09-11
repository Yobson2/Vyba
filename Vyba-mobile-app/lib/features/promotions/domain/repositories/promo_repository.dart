import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promo.dart';

abstract class PromoRepository {
  Future<Either<Failure, Promo>> createPromo({
    required String venueId,
    required String title,
    required String description,
  });
}
