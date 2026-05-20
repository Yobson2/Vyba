import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_bookings/data/datasources/mock_owner_booking_datasource.dart';
import 'package:flutter_templates/features/owner_bookings/domain/entities/owner_booking.dart';
import 'package:flutter_templates/features/owner_bookings/domain/repositories/owner_booking_repository.dart';

class OwnerBookingRepositoryImpl implements OwnerBookingRepository {
  OwnerBookingRepositoryImpl(this._dataSource);

  final OwnerBookingDataSource _dataSource;

  @override
  Future<Either<Failure, List<OwnerBooking>>> getOwnerBookings({
    String? filter,
  }) async {
    try {
      final bookings = await _dataSource.getOwnerBookings(filter: filter);
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OwnerBooking>> confirmBooking(String id) async {
    try {
      final booking = await _dataSource.confirmBooking(id);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OwnerBooking>> declineBooking(String id) async {
    try {
      final booking = await _dataSource.declineBooking(id);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
