import 'package:flutter/foundation.dart';

@immutable
class AnalyticsData {
  const AnalyticsData({
    required this.totalBookings,
    required this.totalViews,
    required this.averageRating,
    required this.revenueEstimate,
    required this.bookingsByDay,
  });

  final int totalBookings;
  final int totalViews;
  final double averageRating;
  final double revenueEstimate;
  final List<MapEntry<String, int>> bookingsByDay;
}
