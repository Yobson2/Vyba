import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_analytics/data/datasources/mock_analytics_datasource.dart';
import 'package:flutter_templates/features/owner_analytics/data/repositories/analytics_repository_impl.dart';
import 'package:flutter_templates/features/owner_analytics/domain/entities/analytics_data.dart';
import 'package:flutter_templates/features/owner_analytics/domain/repositories/analytics_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_providers.g.dart';

@Riverpod(keepAlive: true)
AnalyticsDataSource analyticsDataSource(AnalyticsDataSourceRef ref) {
  return MockAnalyticsDataSource();
}

@Riverpod(keepAlive: true)
AnalyticsRepository analyticsRepository(AnalyticsRepositoryRef ref) {
  return AnalyticsRepositoryImpl(ref.read(analyticsDataSourceProvider));
}

@riverpod
Future<AnalyticsData> ownerAnalytics(
  OwnerAnalyticsRef ref, {
  String? dateRange,
}) async {
  final repo = ref.read(analyticsRepositoryProvider);
  final result = await repo.getAnalytics(dateRange: dateRange);
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (AnalyticsData data) => data,
  );
}
