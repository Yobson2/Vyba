import 'package:flutter_templates/features/promotions/domain/entities/promotion.dart';

abstract class PromotionDataSource {
  Future<Promotion> createPromotion({
    required String title,
    required String description,
    required String imageUrl,
    required PromoType promoType,
    required DateTime startDate,
    required DateTime endDate,
    required String venueId,
    bool isPremiumBoosted,
  });
  Future<List<Promotion>> getMyPromotions();
}

class MockPromotionDataSource implements PromotionDataSource {
  final List<Promotion> _promotions = [
    Promotion(
      id: 'promo-001',
      title: 'Friday Happy Hour',
      description: 'Half-price cocktails from 5PM to 8PM every Friday.',
      imageUrl:
          'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=800',
      promoType: PromoType.happyHour,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      venueId: '1',
      isPremiumBoosted: true,
    ),
    Promotion(
      id: 'promo-002',
      title: 'Live Jazz Night',
      description:
          'Experience world-class jazz performances every Saturday night.',
      imageUrl:
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
      promoType: PromoType.event,
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 2)),
      venueId: '1',
    ),
    Promotion(
      id: 'promo-003',
      title: '20% Off Group Bookings',
      description: 'Book for 6+ guests and save 20% on your total bill.',
      imageUrl:
          'https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=800',
      promoType: PromoType.discount,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 14)),
      venueId: '1',
    ),
  ];

  int _idCounter = 4;

  @override
  Future<Promotion> createPromotion({
    required String title,
    required String description,
    required String imageUrl,
    required PromoType promoType,
    required DateTime startDate,
    required DateTime endDate,
    required String venueId,
    bool isPremiumBoosted = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final promo = Promotion(
      id: 'promo-${_idCounter.toString().padLeft(3, '0')}',
      title: title,
      description: description,
      imageUrl: imageUrl,
      promoType: promoType,
      startDate: startDate,
      endDate: endDate,
      venueId: venueId,
      isPremiumBoosted: isPremiumBoosted,
    );
    _idCounter++;
    _promotions.add(promo);
    return promo;
  }

  @override
  Future<List<Promotion>> getMyPromotions() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_promotions);
  }
}
