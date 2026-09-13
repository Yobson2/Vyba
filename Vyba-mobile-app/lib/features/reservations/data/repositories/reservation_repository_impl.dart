import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/reservations/data/datasources/reservation_remote_datasource.dart';
import 'package:flutter_templates/features/reservations/domain/entities/availability.dart';
import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';
import 'package:flutter_templates/features/reservations/domain/repositories/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  const ReservationRepositoryImpl({
    required ReservationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final ReservationRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, Reservation?>> getMine(String venueId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.getMine(venueId);
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Reservation>> create({
    required String venueId,
    int? partySize,
    String? note,
  }) async {
    // Same rule as "J'y vais" (ADR-0002): an offline tap fails immediately.
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.create(
        venueId: venueId,
        partySize: partySize,
        note: note,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancel(String venueId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.cancel(venueId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Availability>> getAvailability(
    String venueId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.getAvailability(venueId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Reservation>>> listForOwner(
    String venueId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final models = await _remote.listForOwner(venueId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Reservation>> respond({
    required String reservationId,
    required bool confirm,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.respond(
        reservationId: reservationId,
        confirm: confirm,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  ServerFailure _serverFailure(ServerException e) => ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        code: e.code,
      );
}
