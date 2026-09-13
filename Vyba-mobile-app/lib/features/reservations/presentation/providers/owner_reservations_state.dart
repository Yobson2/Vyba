import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_reservations_state.freezed.dart';

/// Tonight's reservation requests for the owner's venue.
@freezed
sealed class OwnerReservationsState with _$OwnerReservationsState {
  const factory OwnerReservationsState.loading() = OwnerReservationsLoading;
  const factory OwnerReservationsState.loaded(List<Reservation> requests) =
      OwnerReservationsLoaded;
  const factory OwnerReservationsState.error(String message) =
      OwnerReservationsError;
}
