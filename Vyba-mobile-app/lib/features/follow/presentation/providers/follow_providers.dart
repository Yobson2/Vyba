import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/follow/data/datasources/follow_remote_datasource.dart';
import 'package:flutter_templates/features/follow/data/repositories/follow_repository_impl.dart';
import 'package:flutter_templates/features/follow/domain/repositories/follow_repository.dart';
import 'package:flutter_templates/features/follow/domain/usecases/follow_venue_usecase.dart';
import 'package:flutter_templates/features/follow/domain/usecases/get_my_followed_venues_usecase.dart';
import 'package:flutter_templates/features/follow/domain/usecases/is_following_usecase.dart';
import 'package:flutter_templates/features/follow/domain/usecases/unfollow_venue_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_providers.g.dart';

@Riverpod(keepAlive: true)
FollowRemoteDataSource followRemoteDataSource(FollowRemoteDataSourceRef ref) {
  return FollowRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
FollowRepository followRepository(FollowRepositoryRef ref) {
  return FollowRepositoryImpl(
    remoteDataSource: ref.watch(followRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
IsFollowingUseCase isFollowingUseCase(IsFollowingUseCaseRef ref) {
  return IsFollowingUseCase(ref.watch(followRepositoryProvider));
}

@riverpod
FollowVenueUseCase followVenueUseCase(FollowVenueUseCaseRef ref) {
  return FollowVenueUseCase(ref.watch(followRepositoryProvider));
}

@riverpod
UnfollowVenueUseCase unfollowVenueUseCase(UnfollowVenueUseCaseRef ref) {
  return UnfollowVenueUseCase(ref.watch(followRepositoryProvider));
}

@riverpod
GetMyFollowedVenuesUseCase getMyFollowedVenuesUseCase(
  GetMyFollowedVenuesUseCaseRef ref,
) {
  return GetMyFollowedVenuesUseCase(ref.watch(followRepositoryProvider));
}
