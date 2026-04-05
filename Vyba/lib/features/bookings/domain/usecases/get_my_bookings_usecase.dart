import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';
import 'package:flutter_templates/features/bookings/domain/repositories/booking_repository.dart';

class GetMyBookingsUseCase extends UseCase<List<Booking>, BookingStatus?> {
  GetMyBookingsUseCase(this._repository);
  final BookingRepository _repository;

  @override
  Future<Either<Failure, List<Booking>>> call(BookingStatus? params) {
    return _repository.getMyBookings(filter: params);
  }
}
