import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/set_headline_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/set_live_usecase.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_providers.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_night_notifier.g.dart';

/// Drives the owner's "on est live ce soir" toggle + headline field.
@riverpod
class VenueNightNotifier extends _$VenueNightNotifier {
  @override
  VenueNightState build() {
    _load();
    return const VenueNightState.loading();
  }

  Future<void> _load() async {
    final venueResult = await ref.read(getMyVenueUseCaseProvider).call(
          const NoParams(),
        );
    await venueResult.fold(
      (failure) async {
        state = VenueNightState.error(message: failure.message);
      },
      (venue) async {
        final tonightResult =
            await ref.read(getTonightUseCaseProvider).call(venue.id);
        state = tonightResult.fold(
          (failure) => VenueNightState.error(message: failure.message),
          (tonight) => VenueNightState.loaded(venue: venue, tonight: tonight),
        );
      },
    );
  }

  /// Toggles live on/off. Returns an error message on failure, or `null` on
  /// success — keeps [state] stable on failure so the UI doesn't blank out.
  Future<String?> toggleLive() async {
    final current = state;
    if (current is! VenueNightLoaded) return null;

    final result = await ref.read(setLiveUseCaseProvider).call(
          SetLiveParams(
            venueId: current.venue.id,
            isLive: !current.tonight.isLive,
          ),
        );
    return result.fold(
      (failure) => failure.message,
      (tonight) {
        state = VenueNightState.loaded(venue: current.venue, tonight: tonight);
        return null;
      },
    );
  }

  Future<String?> updateHeadline({String? headline, String? djName}) async {
    final current = state;
    if (current is! VenueNightLoaded) return null;

    final result = await ref.read(setHeadlineUseCaseProvider).call(
          SetHeadlineParams(
            venueId: current.venue.id,
            headline: headline,
            djName: djName,
          ),
        );
    return result.fold(
      (failure) => failure.message,
      (tonight) {
        state = VenueNightState.loaded(venue: current.venue, tonight: tonight);
        return null;
      },
    );
  }
}
