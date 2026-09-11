import 'package:flutter_templates/features/venue_night/domain/entities/owner_venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_night_state.freezed.dart';

@freezed
sealed class VenueNightState with _$VenueNightState {
  const factory VenueNightState.loading() = VenueNightLoading;
  const factory VenueNightState.loaded({
    required OwnerVenue venue,
    required VenueTonight tonight,
  }) = VenueNightLoaded;
  const factory VenueNightState.error({required String message}) =
      VenueNightError;
}
