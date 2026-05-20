import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/feed/data/datasources/mock_feed_datasource.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';
import 'package:flutter_templates/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl(this._dataSource);

  final FeedDataSource _dataSource;

  @override
  Future<Either<Failure, List<FeedItem>>> getFeed({int page = 1}) async {
    try {
      final items = await _dataSource.getFeed(page: page);
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markInterested(String eventId) async {
    try {
      await _dataSource.markInterested(eventId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
