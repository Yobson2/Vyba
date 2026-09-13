import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/reservations/domain/repositories/reservation_repository.dart';

class CancelReservationUseCase extends UseCase<void, String> {
  const CancelReservationUseCase(this._repository);

  final ReservationRepository _repository;

  @override
  Future<Either<Failure, void>> call(String venueId) {
    return _repository.cancel(venueId);
  }
}
