import 'package:flutter/foundation.dart';

@immutable
class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
  });

  final String id;
  final ActivityType type;
  final String message;
  final DateTime timestamp;
}

enum ActivityType { checkIn, review, promo, system }
