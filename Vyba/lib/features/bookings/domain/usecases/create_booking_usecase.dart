import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';
import 'package:flutter_templates/features/bookings/domain/repositories/booking_repository.dart';

class CreateBookingUseCase extends UseCase<Booking, CreateBookingParams> {
  CreateBookingUseCase(this._repository);
  final BookingRepository _repository;

  @override
  Future<Either<Failure, Booking>> call(CreateBookingParams params) {
    return _repository.createBooking(
      venueId: params.venueId,
      date: params.date,
      timeSlot: params.timeSlot,
      guestCount: params.guestCount,
      zone: params.zone,
    );
  }
}

class CreateBookingParams {
  const CreateBookingParams({
    required this.venueId,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
    required this.zone,
  });

  final String venueId;
  final DateTime date;
  final String timeSlot;
  final int guestCount;
  final BookingZone zone;
}
