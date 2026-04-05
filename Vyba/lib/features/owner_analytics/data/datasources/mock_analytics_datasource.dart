import 'package:flutter_templates/features/owner_analytics/domain/entities/analytics_data.dart';

abstract class AnalyticsDataSource {
  Future<AnalyticsData> getAnalytics({String? dateRange});
}

class MockAnalyticsDataSource implements AnalyticsDataSource {
  @override
  Future<AnalyticsData> getAnalytics({String? dateRange}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final multiplier = switch (dateRange) {
      'week' => 1.0,
      'month' => 4.2,
      'all' => 12.0,
      _ => 1.0,
    };

    return AnalyticsData(
      totalBookings: (156 * multiplier).round(),
      totalViews: (4200 * multiplier).round(),
      averageRating: 4.7,
      revenueEstimate: 2450000 * multiplier,
      bookingsByDay: [
        const MapEntry('Mon', 18),
        const MapEntry('Tue', 24),
        const MapEntry('Wed', 15),
        const MapEntry('Thu', 30),
        const MapEntry('Fri', 42),
        const MapEntry('Sat', 55),
        const MapEntry('Sun', 38),
      ],
    );
  }
}
