import 'package:flutter_templates/features/reservations/domain/usecases/respond_reservation_usecase.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/owner_reservations_state.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/reservation_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_reservations_notifier.g.dart';

/// Tonight's reservation requests for the owner's own venue — list +
/// confirm/reject, keyed by venueId.
@riverpod
class OwnerReservationsNotifier extends _$OwnerReservationsNotifier {
  @override
  OwnerReservationsState build(String venueId) {
    _load();
    return const OwnerReservationsState.loading();
  }

  Future<void> _load() async {
    final result =
        await ref.read(listOwnerReservationsUseCaseProvider).call(venueId);
    state = result.fold(
      (failure) => OwnerReservationsState.error(failure.message),
      OwnerReservationsState.loaded,
    );
  }

  Future<void> respond(String reservationId, {required bool confirm}) async {
    final result = await ref.read(respondReservationUseCaseProvider).call(
          RespondReservationParams(
            reservationId: reservationId,
            confirm: confirm,
          ),
        );
    result.fold(
      (failure) => state = OwnerReservationsState.error(failure.message),
      (_) => _load(),
    );
  }

  Future<void> refresh() => _load();
}
