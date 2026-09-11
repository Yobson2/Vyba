import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promo.dart';
import 'package:flutter_templates/features/promotions/domain/repositories/promo_repository.dart';

class CreatePromoUseCase extends UseCase<Promo, CreatePromoParams> {
  const CreatePromoUseCase(this._repository);

  final PromoRepository _repository;

  @override
  Future<Either<Failure, Promo>> call(CreatePromoParams params) {
    return _repository.createPromo(
      venueId: params.venueId,
      title: params.title,
      description: params.description,
    );
  }
}

@immutable
class CreatePromoParams {
  const CreatePromoParams({
    required this.venueId,
    required this.title,
    required this.description,
  });

  final String venueId;
  final String title;
  final String description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatePromoParams &&
          runtimeType == other.runtimeType &&
          venueId == other.venueId &&
          title == other.title &&
          description == other.description;

  @override
  int get hashCode => Object.hash(venueId, title, description);
}
