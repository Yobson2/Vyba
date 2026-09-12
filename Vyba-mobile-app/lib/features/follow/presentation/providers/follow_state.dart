import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_state.freezed.dart';

/// Follow-toggle state for one venue (ticket 10).
@freezed
sealed class FollowState with _$FollowState {
  const factory FollowState.loading() = FollowLoading;
  const factory FollowState.notFollowing() = FollowNotFollowing;
  const factory FollowState.following() = FollowFollowing;
  const factory FollowState.error(String message) = FollowErrorState;
}
