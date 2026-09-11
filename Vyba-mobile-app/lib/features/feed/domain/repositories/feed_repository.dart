import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_result.dart';

abstract class FeedRepository {
  /// Page 1 falls back to the last cached feed when offline or on a server
  /// error; later pages simply fail (nothing to page through offline).
  Future<Either<Failure, FeedResult>> getFeed({
    required int page,
    required int limit,
  });
}
