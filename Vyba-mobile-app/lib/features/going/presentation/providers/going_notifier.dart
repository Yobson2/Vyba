import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/providers/analytics_provider.dart';
import 'package:flutter_templates/features/going/domain/usecases/mark_going_usecase.dart';
import 'package:flutter_templates/features/going/presentation/providers/going_providers.dart';
import 'package:flutter_templates/features/going/presentation/providers/going_state.dart';
import 'package:flutter_templates/features/going/presentation/utils/going_error_copy.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_detail_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'going_notifier.g.dart';

const _selfMarkErrorCode = 'GOING_002';

/// One venue's "J'y vais" state, keyed by venueId.
@riverpod
class GoingNotifier extends _$GoingNotifier {
  @override
  GoingState build(String venueId) {
    _load();
    return const GoingState.loading();
  }

  Future<void> _load() async {
    final result = await ref.read(getMineUseCaseProvider).call(venueId);
    state = result.fold(
      _mapFailure,
      (going) => going == null
          ? const GoingState.notMarked()
          : GoingState.marked(going),
    );
  }

  Future<void> mark({int? partySize, bool? identityPublic}) async {
    state = const GoingState.loading();
    final result = await ref.read(markGoingUseCaseProvider).call(
          GoingActionParams(
            venueId: venueId,
            partySize: partySize,
            identityPublic: identityPublic,
          ),
        );
    state = result.fold(_mapFailure, (going) {
      ref.read(analyticsServiceProvider).logEvent('going_marked', {
        'venue_id': venueId,
        'party_size': going.partySize,
      });
      _refreshVenueDetail();
      return GoingState.marked(going);
    });
  }

  Future<void> update({int? partySize, bool? identityPublic}) async {
    final current = state;
    if (current is! GoingMarked) return;
    state = const GoingState.loading();
    final result = await ref.read(updateGoingUseCaseProvider).call(
          GoingActionParams(
            venueId: venueId,
            partySize: partySize,
            identityPublic: identityPublic,
          ),
        );
    state = result.fold(_mapFailure, GoingState.marked);
  }

  Future<void> cancel() async {
    state = const GoingState.loading();
    final result = await ref.read(cancelGoingUseCaseProvider).call(venueId);
    state = result.fold(_mapFailure, (_) {
      ref
          .read(analyticsServiceProvider)
          .logEvent('going_cancelled', {'venue_id': venueId});
      _refreshVenueDetail();
      return const GoingState.notMarked();
    });
  }

  void _refreshVenueDetail() {
    // "Poll-on-view": the count shown on the venue page comes from
    // `tonight.goingCount` — force it to refetch right after a mark/cancel.
    // Only touch it if it's already alive; invalidating an absent provider
    // would otherwise force an eager build of an unrelated dependency chain.
    final provider = venueDetailNotifierProvider(venueId);
    if (ref.exists(provider)) {
      ref.invalidate(provider);
    }
  }

  GoingState _mapFailure(Failure failure) {
    if (failure is NetworkFailure) return const GoingState.offline();
    if (failure.code == _selfMarkErrorCode)
      return const GoingState.ownedVenue();
    return GoingState.error(goingErrorMessage(failure.code));
  }
}
