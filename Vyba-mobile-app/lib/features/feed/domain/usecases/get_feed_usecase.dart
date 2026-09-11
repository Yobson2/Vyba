import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_result.dart';
import 'package:flutter_templates/features/feed/domain/repositories/feed_repository.dart';

class GetFeedUseCase extends UseCase<FeedResult, GetFeedParams> {
  const GetFeedUseCase(this._repository);

  final FeedRepository _repository;

  @override
  Future<Either<Failure, FeedResult>> call(GetFeedParams params) {
    return _repository.getFeed(page: params.page, limit: params.limit);
  }
}

@immutable
class GetFeedParams {
  const GetFeedParams({required this.page, this.limit = 20});

  final int page;
  final int limit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetFeedParams &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => Object.hash(page, limit);
}
