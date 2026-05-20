import 'package:flutter/foundation.dart';

@immutable
class Promotion {
  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.promoType,
    required this.startDate,
    required this.endDate,
    required this.venueId,
    this.isPremiumBoosted = false,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final PromoType promoType;
  final DateTime startDate;
  final DateTime endDate;
  final String venueId;
  final bool isPremiumBoosted;
}

enum PromoType { happyHour, event, discount }
