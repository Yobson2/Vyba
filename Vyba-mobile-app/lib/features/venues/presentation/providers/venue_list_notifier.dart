import 'package:flutter_templates/core/providers/location_provider.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_filter.dart';
import 'package:flutter_templates/features/venues/domain/usecases/get_venues_usecase.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_list_state.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_list_notifier.g.dart';

@riverpod
class VenueListNotifier extends _$VenueListNotifier {
  @override
  VenueListState build() {
    _loadVenues(const VenueFilter());
    return const VenueListState.loading();
  }

  Future<void> _loadVenues(VenueFilter filter) async {
    final useCase = ref.read(getVenuesUseCaseProvider);
    final result = await useCase(GetVenuesParams(filter: filter));
    result.fold(
      (failure) => state = VenueListState.error(message: failure.message),
      (venues) =>
          state = VenueListState.loaded(venues: venues, filter: filter),
    );
  }

  /// Text search by name/address (ADR-0005) — replaces any active "nearby"
  /// sort, matching a fresh explicit search intent.
  Future<void> search(String query) async {
    state = const VenueListState.loading();
    await _loadVenues(VenueFilter(query: query.trim().isEmpty ? null : query));
  }

  /// "Nearby" filter chip: gets the device's position and refetches sorted
  /// by distance. Surfaces a location-failure message rather than failing
  /// silently when permission is denied or the location service is off.
  Future<void> useNearbyMe() async {
    state = const VenueListState.loading();
    final locationResult =
        await ref.read(locationServiceProvider).getCurrentPosition();

    await locationResult.fold(
      (failure) async =>
          state = VenueListState.error(message: failure.message),
      (position) => _loadVenues(
        VenueFilter(
          latitude: position.latitude,
          longitude: position.longitude,
          sortBy: VenueSortBy.distance,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final currentFilter = switch (state) {
      VenueListLoaded(:final filter) => filter,
      _ => const VenueFilter(),
    };
    state = const VenueListState.loading();
    await _loadVenues(currentFilter);
  }
}
