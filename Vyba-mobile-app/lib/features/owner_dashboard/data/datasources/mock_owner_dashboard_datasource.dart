import 'package:flutter_templates/features/owner_dashboard/domain/entities/activity_item.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/dashboard_stats.dart';

abstract class OwnerDashboardDataSource {
  Future<DashboardStats> getDashboardStats();
  Future<List<ActivityItem>> getRecentActivity();
}

class MockOwnerDashboardDataSource implements OwnerDashboardDataSource {
  @override
  Future<DashboardStats> getDashboardStats() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const DashboardStats(
      todayVisits: 24,
      activePromos: 3,
      weekViews: 1200,
      visitsTrend: 12,
    );
  }

  @override
  Future<List<ActivityItem>> getRecentActivity() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return [
      ActivityItem(
        id: 'act-1',
        type: ActivityType.checkIn,
        message: 'Amara Obi checked in with 6 guests',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ActivityItem(
        id: 'act-2',
        type: ActivityType.review,
        message: 'New 5-star review from Chidi Eze on The Vibe Lounge',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ActivityItem(
        id: 'act-3',
        type: ActivityType.system,
        message: 'Your Happy Hour promo reaches 500+ views',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}
