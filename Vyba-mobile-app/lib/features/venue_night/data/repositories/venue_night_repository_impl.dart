import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/venue_night/data/datasources/venue_night_remote_datasource.dart';
import 'package:flutter_templates/features/venue_night/domain/entities/owner_venue.dart';
import 'package:flutter_templates/features/venue_night/domain/repositories/venue_night_repository.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';

class VenueNightRepositoryImpl implements VenueNightRepository {
  const VenueNightRepositoryImpl({
    required VenueNightRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final VenueNightRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, OwnerVenue>> getMyVenue() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.getMyVenue();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, statusCode: e.statusCode, code: e.code));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, VenueTonight>> getTonight(String venueId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.getTonight(venueId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, statusCode: e.statusCode, code: e.code));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, VenueTonight>> setLive({
    required String venueId,
    required bool isLive,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.setLive(venueId: venueId, isLive: isLive);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, statusCode: e.statusCode, code: e.code));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, VenueTonight>> setHeadline({
    required String venueId,
    String? headline,
    String? djName,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.setHeadline(
        venueId: venueId,
        headline: headline,
        djName: djName,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message, statusCode: e.statusCode, code: e.code));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
