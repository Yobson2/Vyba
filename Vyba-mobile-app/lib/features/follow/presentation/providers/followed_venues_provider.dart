import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/follow/domain/entities/followed_venue.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followed_venues_provider.g.dart';

/// "Mes lieux suivis" (ticket 10).
@riverpod
class FollowedVenues extends _$FollowedVenues {
  @override
  Future<List<FollowedVenue>> build() async {
    final result = await ref
        .read(getMyFollowedVenuesUseCaseProvider)
        .call(const NoParams());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (v) => v,
    );
  }

  /// Called after an inline unfollow from the list itself, so the removed
  /// venue disappears without waiting for a manual pull-to-refresh.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
