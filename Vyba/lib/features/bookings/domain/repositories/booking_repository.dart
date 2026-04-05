import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<String>>> getAvailableSlots(
    String venueId,
    DateTime date,
  );
  Future<Either<Failure, Booking>> createBooking({
    required String venueId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    required BookingZone zone,
  });
  Future<Either<Failure, List<Booking>>> getMyBookings({
    BookingStatus? filter,
  });
  Future<Either<Failure, void>> cancelBooking(String bookingId);
}
