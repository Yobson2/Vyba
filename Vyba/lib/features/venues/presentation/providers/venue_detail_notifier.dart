import 'package:flutter_templates/features/venues/presentation/providers/venue_detail_state.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_detail_notifier.g.dart';

@riverpod
class VenueDetailNotifier extends _$VenueDetailNotifier {
  @override
  VenueDetailState build(String venueId) {
    _loadVenue();
    return const VenueDetailState.loading();
  }

  Future<void> _loadVenue() async {
    final useCase = ref.read(getVenueDetailUseCaseProvider);
    final result = await useCase(venueId);
    result.fold(
      (failure) => state = VenueDetailState.error(message: failure.message),
      (venue) => state = VenueDetailState.loaded(venue: venue),
    );
  }
}
