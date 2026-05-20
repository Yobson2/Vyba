import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_analytics/domain/entities/analytics_data.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsData>> getAnalytics({String? dateRange});
}
