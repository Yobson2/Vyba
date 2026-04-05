import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/bookings/data/datasources/mock_booking_datasource.dart';
import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';
import 'package:flutter_templates/features/bookings/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._dataSource);

  final BookingDataSource _dataSource;

  @override
  Future<Either<Failure, List<String>>> getAvailableSlots(
    String venueId,
    DateTime date,
  ) async {
    try {
      final slots = await _dataSource.getAvailableSlots(venueId, date);
      return Right(slots);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> createBooking({
    required String venueId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    required BookingZone zone,
  }) async {
    try {
      final booking = await _dataSource.createBooking(
        venueId: venueId,
        date: date,
        timeSlot: timeSlot,
        guestCount: guestCount,
        zone: zone,
      );
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getMyBookings({
    BookingStatus? filter,
  }) async {
    try {
      final bookings = await _dataSource.getMyBookings(filter: filter);
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    try {
      await _dataSource.cancelBooking(bookingId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
