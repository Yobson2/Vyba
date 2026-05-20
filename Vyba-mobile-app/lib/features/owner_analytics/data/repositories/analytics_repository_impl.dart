import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_analytics/data/datasources/mock_analytics_datasource.dart';
import 'package:flutter_templates/features/owner_analytics/domain/entities/analytics_data.dart';
import 'package:flutter_templates/features/owner_analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._dataSource);

  final AnalyticsDataSource _dataSource;

  @override
  Future<Either<Failure, AnalyticsData>> getAnalytics({
    String? dateRange,
  }) async {
    try {
      final data = await _dataSource.getAnalytics(dateRange: dateRange);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
