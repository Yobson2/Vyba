import 'package:flutter_templates/features/promotions/domain/entities/promo.dart';

/// Parses the backend's create-promo response (the raw `FeedItem` it
/// creates) into [Promo] — a plain factory rather than freezed, since
/// `title`/`description` live nested under `payload` (mirrors
/// `FeedItemModel`'s dispatch for the same polymorphic shape).
class PromoModel {
  const PromoModel._();

  static Promo fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>?;
    return Promo(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      title: payload?['title'] as String? ?? '',
      description: payload?['description'] as String? ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
