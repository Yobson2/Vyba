import 'package:flutter_templates/core/providers/analytics_provider.dart';
import 'package:flutter_templates/features/promotions/domain/usecases/create_promo_usecase.dart';
import 'package:flutter_templates/features/promotions/presentation/providers/create_promo_state.dart';
import 'package:flutter_templates/features/promotions/presentation/providers/promo_providers.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_notifier.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_promo_notifier.g.dart';

/// Drives the owner's create-promo form (ticket 09) — title + description,
/// published for the owner's own venue (known from
/// [venueNightNotifierProvider], already loaded on Accueil; avoids a second
/// "which venue is mine" round trip).
@Riverpod(keepAlive: true)
class CreatePromoNotifier extends _$CreatePromoNotifier {
  @override
  CreatePromoState build() => const CreatePromoState();

  Future<bool> submit({
    required String title,
    required String description,
  }) async {
    final nightState = ref.read(venueNightNotifierProvider);
    if (nightState is! VenueNightLoaded) {
      state = state.copyWith(errorMessage: 'Venue introuvable.');
      return false;
    }

    state = state.copyWith(submitting: true, errorMessage: null);
    final result = await ref.read(createPromoUseCaseProvider).call(
          CreatePromoParams(
            venueId: nightState.venue.id,
            title: title,
            description: description,
          ),
        );
    return result.fold(
      (failure) {
        state = state.copyWith(submitting: false, errorMessage: failure.message);
        return false;
      },
      (promo) {
        ref.read(analyticsServiceProvider)
          ..logEvent('promo_created', {'venue_id': promo.venueId})
          ..logEvent(
            'post_created',
            {'venue_id': promo.venueId, 'type': 'promo'},
          )
          ..logEvent(
            'post_created_organically',
            {'venue_id': promo.venueId, 'type': 'promo'},
          );
        state = CreatePromoState(lastPublished: promo);
        return true;
      },
    );
  }
}
