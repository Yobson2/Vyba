import 'package:flutter/foundation.dart';

@immutable
class DashboardStats {
  const DashboardStats({
    required this.todayBookings,
    required this.activePromos,
    required this.weekViews,
    this.bookingsTrend = 0,
  });

  final int todayBookings;
  final int activePromos;
  final int weekViews;
  final double bookingsTrend;

  String get formattedViews {
    if (weekViews >= 1000) return '${(weekViews / 1000).toStringAsFixed(1)}k';
    return '$weekViews';
  }
}
