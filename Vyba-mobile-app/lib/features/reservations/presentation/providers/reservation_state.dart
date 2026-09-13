import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation_state.freezed.dart';

/// My reservation state for one venue tonight.
@freezed
sealed class ReservationState with _$ReservationState {
  const factory ReservationState.loading() = ReservationLoading;
  const factory ReservationState.notRequested() = ReservationNotRequested;
  const factory ReservationState.pending(Reservation reservation) =
      ReservationPending;
  const factory ReservationState.confirmed(Reservation reservation) =
      ReservationConfirmed;

  /// The signed-in user owns this venue — the backend refuses the request.
  const factory ReservationState.ownedVenue() = ReservationOwnedVenue;

  /// Tapped while offline — fails immediately, no call, no queue (same rule as "J'y vais").
  const factory ReservationState.offline() = ReservationOffline;

  const factory ReservationState.error(String message) = ReservationErrorState;
}
