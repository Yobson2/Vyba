import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:flutter_templates/features/reservations/domain/repositories/reservation_repository.dart';

class GetMineReservationUseCase extends UseCase<Reservation?, String> {
  const GetMineReservationUseCase(this._repository);

  final ReservationRepository _repository;

  @override
  Future<Either<Failure, Reservation?>> call(String venueId) {
    return _repository.getMine(venueId);
  }
}
