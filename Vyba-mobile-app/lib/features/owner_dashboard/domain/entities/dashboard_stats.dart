import 'package:flutter/foundation.dart';

@immutable
class DashboardStats {
  const DashboardStats({
    required this.todayVisits,
    required this.activePromos,
    required this.weekViews,
    this.visitsTrend = 0,
  });

  final int todayVisits;
  final int activePromos;
  final int weekViews;
  final double visitsTrend;

  String get formattedViews {
    if (weekViews >= 1000) return '${(weekViews / 1000).toStringAsFixed(1)}k';
    return '$weekViews';
  }
}
