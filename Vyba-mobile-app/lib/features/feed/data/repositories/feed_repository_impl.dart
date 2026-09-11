import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:flutter_templates/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:flutter_templates/features/feed/data/models/feed_item_model.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_result.dart';
import 'package:flutter_templates/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  const FeedRepositoryImpl({
    required FeedRemoteDataSource remoteDataSource,
    required FeedLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo;

  final FeedRemoteDataSource _remote;
  final FeedLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, FeedResult>> getFeed({
    required int page,
    required int limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return _cachedResultOrFailure(page, const NetworkFailure());
    }

    try {
      final raw = await _remote.getFeed(
        limit: limit,
        offset: (page - 1) * limit,
      );
      if (page == 1) {
        await _local.cacheFeed(raw);
      }
      return Right(
        FeedResult(
          items: raw.map(FeedItemModel.fromJson).toList(),
          isFromCache: false,
          hasMore: raw.length == limit,
        ),
      );
    } on ServerException catch (e) {
      return _cachedResultOrFailure(
        page,
        ServerFailure(
            message: e.message, statusCode: e.statusCode, code: e.code),
      );
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return _cachedResultOrFailure(page, const NetworkFailure());
    }
  }

  /// Page 1 only: falls back to the last cached feed instead of surfacing
  /// [fallback] as an error, so offline/flaky-network opens the app to a
  /// list, not a blank error screen.
  Either<Failure, FeedResult> _cachedResultOrFailure(
    int page,
    Failure fallback,
  ) {
    if (page != 1) return Left(fallback);
    final cached = _local.getCachedFeed();
    if (cached == null) return Left(fallback);
    return Right(
      FeedResult(
        items: cached.map(FeedItemModel.fromJson).toList(),
        isFromCache: true,
        hasMore: false,
      ),
    );
  }
}
