import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<FeedItem>>> getFeed({int page = 1});
  Future<Either<Failure, void>> markInterested(String eventId);
}
