import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/reservations/domain/entities/availability.dart';
import 'package:flutter_templates/features/reservations/domain/repositories/reservation_repository.dart';

class GetAvailabilityUseCase extends UseCase<Availability, String> {
  const GetAvailabilityUseCase(this._repository);

  final ReservationRepository _repository;

  @override
  Future<Either<Failure, Availability>> call(String venueId) {
    return _repository.getAvailability(venueId);
  }
}
