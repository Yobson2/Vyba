import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:flutter_templates/features/reservations/domain/repositories/reservation_repository.dart';

class RespondReservationUseCase
    extends UseCase<Reservation, RespondReservationParams> {
  const RespondReservationUseCase(this._repository);

  final ReservationRepository _repository;

  @override
  Future<Either<Failure, Reservation>> call(
    RespondReservationParams params,
  ) {
    return _repository.respond(
      reservationId: params.reservationId,
      confirm: params.confirm,
    );
  }
}

@immutable
class RespondReservationParams {
  const RespondReservationParams({
    required this.reservationId,
    required this.confirm,
  });

  final String reservationId;

  /// `true` to confirm, `false` to reject.
  final bool confirm;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RespondReservationParams &&
          runtimeType == other.runtimeType &&
          reservationId == other.reservationId &&
          confirm == other.confirm;

  @override
  int get hashCode => Object.hash(reservationId, confirm);
}
