import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/activity_item.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/dashboard_stats.dart';

abstract class OwnerDashboardRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats();
  Future<Either<Failure, List<ActivityItem>>> getRecentActivity();
}
