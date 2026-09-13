import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:flutter_templates/features/reservations/domain/repositories/reservation_repository.dart';

class CreateReservationUseCase
    extends UseCase<Reservation, CreateReservationParams> {
  const CreateReservationUseCase(this._repository);

  final ReservationRepository _repository;

  @override
  Future<Either<Failure, Reservation>> call(CreateReservationParams params) {
    return _repository.create(
      venueId: params.venueId,
      partySize: params.partySize,
      note: params.note,
    );
  }
}

@immutable
class CreateReservationParams {
  const CreateReservationParams({
    required this.venueId,
    this.partySize,
    this.note,
  });

  final String venueId;
  final int? partySize;
  final String? note;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateReservationParams &&
          runtimeType == other.runtimeType &&
          venueId == other.venueId &&
          partySize == other.partySize &&
          note == other.note;

  @override
  int get hashCode => Object.hash(venueId, partySize, note);
}
