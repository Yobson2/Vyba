import 'package:flutter_templates/features/venues/domain/usecases/get_venues_usecase.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_list_state.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_list_notifier.g.dart';

@riverpod
class VenueListNotifier extends _$VenueListNotifier {
  @override
  VenueListState build() {
    _loadVenues();
    return const VenueListState.loading();
  }

  Future<void> _loadVenues() async {
    final useCase = ref.read(getVenuesUseCaseProvider);
    final result = await useCase(const GetVenuesParams());
    result.fold(
      (failure) => state = VenueListState.error(message: failure.message),
      (venues) => state = VenueListState.loaded(venues: venues),
    );
  }

  Future<void> refresh() async {
    state = const VenueListState.loading();
    await _loadVenues();
  }
}
