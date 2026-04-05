import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_filter.dart';

part 'venue_list_state.freezed.dart';

@freezed
sealed class VenueListState with _$VenueListState {
  const factory VenueListState.initial() = VenueListInitial;
  const factory VenueListState.loading() = VenueListLoading;
  const factory VenueListState.loaded({
    required List<Venue> venues,
    @Default(false) bool hasMore,
    @Default(VenueFilter()) VenueFilter filter,
  }) = VenueListLoaded;
  const factory VenueListState.error({required String message}) =
      VenueListError;
}
