import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_dashboard/data/datasources/mock_owner_dashboard_datasource.dart';
import 'package:flutter_templates/features/owner_dashboard/data/repositories/owner_dashboard_repository_impl.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/activity_item.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/dashboard_stats.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/repositories/owner_dashboard_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_dashboard_providers.g.dart';

@Riverpod(keepAlive: true)
OwnerDashboardDataSource ownerDashboardDataSource(
  OwnerDashboardDataSourceRef ref,
) {
  return MockOwnerDashboardDataSource();
}

@Riverpod(keepAlive: true)
OwnerDashboardRepository ownerDashboardRepository(
  OwnerDashboardRepositoryRef ref,
) {
  return OwnerDashboardRepositoryImpl(
    ref.read(ownerDashboardDataSourceProvider),
  );
}

@riverpod
Future<DashboardStats> dashboardStats(DashboardStatsRef ref) async {
  final repo = ref.read(ownerDashboardRepositoryProvider);
  final result = await repo.getDashboardStats();
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (DashboardStats stats) => stats,
  );
}

@riverpod
Future<List<ActivityItem>> recentActivity(RecentActivityRef ref) async {
  final repo = ref.read(ownerDashboardRepositoryProvider);
  final result = await repo.getRecentActivity();
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (List<ActivityItem> activity) => activity,
  );
}
