import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_bookings/domain/entities/owner_booking.dart';

abstract class OwnerBookingRepository {
  Future<Either<Failure, List<OwnerBooking>>> getOwnerBookings({
    String? filter,
  });
  Future<Either<Failure, OwnerBooking>> confirmBooking(String id);
  Future<Either<Failure, OwnerBooking>> declineBooking(String id);
}
