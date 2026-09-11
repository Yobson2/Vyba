import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:flutter_templates/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:flutter_templates/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:flutter_templates/features/feed/domain/repositories/feed_repository.dart';
import 'package:flutter_templates/features/feed/domain/usecases/get_feed_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_providers.g.dart';

@Riverpod(keepAlive: true)
FeedRemoteDataSource feedRemoteDataSource(FeedRemoteDataSourceRef ref) {
  return FeedRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
FeedLocalDataSource feedLocalDataSource(FeedLocalDataSourceRef ref) {
  return FeedLocalDataSourceImpl(ref.watch(localStorageProvider));
}

@Riverpod(keepAlive: true)
FeedRepository feedRepository(FeedRepositoryRef ref) {
  return FeedRepositoryImpl(
    remoteDataSource: ref.watch(feedRemoteDataSourceProvider),
    localDataSource: ref.watch(feedLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
GetFeedUseCase getFeedUseCase(GetFeedUseCaseRef ref) {
  return GetFeedUseCase(ref.watch(feedRepositoryProvider));
}
