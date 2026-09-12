import 'package:flutter_templates/features/owner_broadcast/domain/usecases/send_broadcast_usecase.dart';
import 'package:flutter_templates/features/owner_broadcast/presentation/providers/owner_broadcast_providers.dart';
import 'package:flutter_templates/features/owner_broadcast/presentation/providers/owner_broadcast_state.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_notifier.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_broadcast_notifier.g.dart';

/// Drives "prévenir ceux qui viennent ce soir" (ticket 17) — the owner's
/// venue comes from [venueNightNotifierProvider], already loaded on Accueil,
/// same seam `CreatePromoNotifier` uses.
@Riverpod(keepAlive: true)
class OwnerBroadcastNotifier extends _$OwnerBroadcastNotifier {
  @override
  OwnerBroadcastState build() => const OwnerBroadcastState();

  Future<void> send(String message) async {
    final nightState = ref.read(venueNightNotifierProvider);
    if (nightState is! VenueNightLoaded) {
      state = state.copyWith(errorMessage: 'Venue introuvable.');
      return;
    }

    state = state.copyWith(submitting: true, errorMessage: null);
    final result = await ref.read(sendBroadcastUseCaseProvider).call(
          SendBroadcastParams(venueId: nightState.venue.id, message: message),
        );
    result.fold(
      (failure) {
        state = failure.statusCode == 409
            ? state.copyWith(submitting: false, alreadySentTonight: true)
            : state.copyWith(submitting: false, errorMessage: failure.message);
      },
      (_) => state = state.copyWith(submitting: false, sent: true),
    );
  }
}
