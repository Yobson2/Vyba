import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/promotions/data/datasources/mock_promotion_datasource.dart';
import 'package:flutter_templates/features/promotions/data/repositories/promotion_repository_impl.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promotion.dart';
import 'package:flutter_templates/features/promotions/domain/repositories/promotion_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promotion_providers.g.dart';

@Riverpod(keepAlive: true)
PromotionDataSource promotionDataSource(PromotionDataSourceRef ref) {
  return MockPromotionDataSource();
}

@Riverpod(keepAlive: true)
PromotionRepository promotionRepository(PromotionRepositoryRef ref) {
  return PromotionRepositoryImpl(ref.read(promotionDataSourceProvider));
}

@riverpod
Future<List<Promotion>> myPromotions(MyPromotionsRef ref) async {
  final repo = ref.read(promotionRepositoryProvider);
  final result = await repo.getMyPromotions();
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (List<Promotion> promos) => promos,
  );
}

@riverpod
class CreatePromotionNotifier extends _$CreatePromotionNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> create({
    required String title,
    required String description,
    required PromoType promoType,
    required DateTime startDate,
    required DateTime endDate,
    required String venueId,
    bool isPremiumBoosted = false,
  }) async {
    state = const AsyncLoading<void>();
    final repo = ref.read(promotionRepositoryProvider);
    final result = await repo.createPromotion(
      title: title,
      description: description,
      imageUrl: '',
      promoType: promoType,
      startDate: startDate,
      endDate: endDate,
      venueId: venueId,
      isPremiumBoosted: isPremiumBoosted,
    );
    return result.fold(
      (Failure failure) {
        state = AsyncError<void>(Exception(failure.message), StackTrace.current);
        return false;
      },
      (_) {
        ref.invalidate(myPromotionsProvider);
        state = const AsyncData<void>(null);
        return true;
      },
    );
  }
}
