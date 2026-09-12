import 'package:flutter_templates/features/follow/presentation/providers/follow_providers.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_notifier.g.dart';

/// Follow toggle for one venue, keyed by venueId — optimistic with rollback
/// on failure, idempotent (ticket 10). `venue_followed`/`venue_unfollowed`
/// are emitted server-side by `FollowsService` (ticket 11), not duplicated
/// here.
@riverpod
class FollowNotifier extends _$FollowNotifier {
  @override
  FollowState build(String venueId) {
    _load();
    return const FollowState.loading();
  }

  Future<void> _load() async {
    final result = await ref.read(isFollowingUseCaseProvider).call(venueId);
    state = result.fold(
      (failure) => FollowState.error(failure.message),
      (following) => following
          ? const FollowState.following()
          : const FollowState.notFollowing(),
    );
  }

  Future<void> toggle() async {
    final current = state;
    if (current is FollowFollowing) {
      state = const FollowState.notFollowing();
      final result =
          await ref.read(unfollowVenueUseCaseProvider).call(venueId);
      result.fold(
        // Rollback — the optimistic unfollow didn't actually land.
        (failure) => state = const FollowState.following(),
        (_) {},
      );
      return;
    }

    if (current is FollowNotFollowing) {
      state = const FollowState.following();
      final result = await ref.read(followVenueUseCaseProvider).call(venueId);
      result.fold(
        // Rollback — the optimistic follow didn't actually land.
        (failure) => state = const FollowState.notFollowing(),
        (_) {},
      );
    }
  }
}
