import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';

part 'venue_detail_state.freezed.dart';

@freezed
sealed class VenueDetailState with _$VenueDetailState {
  const factory VenueDetailState.loading() = VenueDetailLoading;
  const factory VenueDetailState.loaded({required Venue venue}) =
      VenueDetailLoaded;
  const factory VenueDetailState.error({required String message}) =
      VenueDetailError;
}
