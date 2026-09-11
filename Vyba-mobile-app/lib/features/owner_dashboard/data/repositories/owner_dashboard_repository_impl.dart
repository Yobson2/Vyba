import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_dashboard/data/datasources/mock_owner_dashboard_datasource.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/activity_item.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/dashboard_stats.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/repositories/owner_dashboard_repository.dart';

class OwnerDashboardRepositoryImpl implements OwnerDashboardRepository {
  OwnerDashboardRepositoryImpl(this._dataSource);

  final OwnerDashboardDataSource _dataSource;

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats() async {
    try {
      final stats = await _dataSource.getDashboardStats();
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityItem>>> getRecentActivity() async {
    try {
      final activity = await _dataSource.getRecentActivity();
      return Right(activity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
