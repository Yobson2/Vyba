import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_providers.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_opt_in_notifier.g.dart';

/// Broadcast opt-in toggle for one venue, keyed by venueId (ticket 17) —
/// optimistic with rollback on failure, mirroring `FollowNotifier` exactly
/// except this is a wholly separate choice from following.
@riverpod
class BroadcastOptInNotifier extends _$BroadcastOptInNotifier {
  @override
  BroadcastOptInState build(String venueId) {
    _load();
    return const BroadcastOptInState.loading();
  }

  Future<void> _load() async {
    final result = await ref.read(isOptedInUseCaseProvider).call(venueId);
    state = result.fold(
      (failure) => BroadcastOptInState.error(failure.message),
      (optedIn) => optedIn
          ? const BroadcastOptInState.optedIn()
          : const BroadcastOptInState.optedOut(),
    );
  }

  Future<void> toggle() async {
    final current = state;
    if (current is BroadcastOptedIn) {
      state = const BroadcastOptInState.optedOut();
      final result = await ref.read(optOutUseCaseProvider).call(venueId);
      result.fold(
        // Rollback — the optimistic opt-out didn't actually land.
        (failure) => state = const BroadcastOptInState.optedIn(),
        (_) {},
      );
      return;
    }

    if (current is BroadcastOptedOut) {
      state = const BroadcastOptInState.optedIn();
      final result = await ref.read(optInUseCaseProvider).call(venueId);
      result.fold(
        // Rollback — the optimistic opt-in didn't actually land.
        (failure) => state = const BroadcastOptInState.optedOut(),
        (_) {},
      );
    }
  }
}
