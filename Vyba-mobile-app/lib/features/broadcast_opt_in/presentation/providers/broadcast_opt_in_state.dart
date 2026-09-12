import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_opt_in_state.freezed.dart';

/// Per-venue broadcast opt-in toggle state (ticket 17) — deliberately its
/// own state, not shared with `FollowState`: opting in is a separate choice.
@freezed
sealed class BroadcastOptInState with _$BroadcastOptInState {
  const factory BroadcastOptInState.loading() = BroadcastOptInLoading;
  const factory BroadcastOptInState.optedOut() = BroadcastOptedOut;
  const factory BroadcastOptInState.optedIn() = BroadcastOptedIn;
  const factory BroadcastOptInState.error(String message) = BroadcastOptInError;
}
