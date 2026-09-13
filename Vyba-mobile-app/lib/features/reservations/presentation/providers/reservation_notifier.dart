import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:flutter_templates/features/reservations/domain/usecases/create_reservation_usecase.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/availability_provider.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/reservation_providers.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/reservation_state.dart';
import 'package:flutter_templates/features/reservations/presentation/utils/reservation_error_copy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reservation_notifier.g.dart';

const _selfMarkErrorCode = 'RESERVATION_002';

/// One venue's reservation state, keyed by venueId.
@riverpod
class ReservationNotifier extends _$ReservationNotifier {
  @override
  ReservationState build(String venueId) {
    _load();
    return const ReservationState.loading();
  }

  Future<void> _load() async {
    final result = await ref.read(getMineReservationUseCaseProvider).call(
          venueId,
        );
    state = result.fold(_mapFailure, _mapReservation);
  }

  Future<void> create({int? partySize, String? note}) async {
    state = const ReservationState.loading();
    final result = await ref.read(createReservationUseCaseProvider).call(
          CreateReservationParams(
            venueId: venueId,
            partySize: partySize,
            note: note,
          ),
        );
    state = result.fold(_mapFailure, (reservation) {
      _refreshAvailability();
      return _mapReservation(reservation);
    });
  }

  Future<void> cancel() async {
    state = const ReservationState.loading();
    final result = await ref.read(cancelReservationUseCaseProvider).call(
          venueId,
        );
    state = result.fold(_mapFailure, (_) {
      _refreshAvailability();
      return const ReservationState.notRequested();
    });
  }

  void _refreshAvailability() {
    final provider = availabilityProvider(venueId);
    ref.invalidate(provider);
  }

  ReservationState _mapReservation(Reservation? reservation) {
    if (reservation == null) return const ReservationState.notRequested();
    return switch (reservation.status) {
      ReservationStatus.confirmed => ReservationState.confirmed(reservation),
      _ => ReservationState.pending(reservation),
    };
  }

  ReservationState _mapFailure(Failure failure) {
    if (failure is NetworkFailure) return const ReservationState.offline();
    if (failure.code == _selfMarkErrorCode) {
      return const ReservationState.ownedVenue();
    }
    return ReservationState.error(reservationErrorMessage(failure.code));
  }
}
