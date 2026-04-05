import 'package:flutter_templates/features/feed/data/datasources/mock_feed_datasource.dart';
import 'package:flutter_templates/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:flutter_templates/features/feed/domain/repositories/feed_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_providers.g.dart';

@Riverpod(keepAlive: true)
FeedDataSource feedDataSource(FeedDataSourceRef ref) {
  return MockFeedDataSource();
}

@Riverpod(keepAlive: true)
FeedRepository feedRepository(FeedRepositoryRef ref) {
  return FeedRepositoryImpl(ref.read(feedDataSourceProvider));
}
