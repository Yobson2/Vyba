import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/going/data/datasources/going_remote_datasource.dart';
import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:flutter_templates/features/going/domain/entities/owner_going_summary.dart';
import 'package:flutter_templates/features/going/domain/repositories/going_repository.dart';

class GoingRepositoryImpl implements GoingRepository {
  const GoingRepositoryImpl({
    required GoingRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final GoingRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, Going?>> getMine(String venueId) async {
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
  Future<Either<Failure, Going>> mark({
    required String venueId,
    int? partySize,
    bool? identityPublic,
  }) async {
    // ADR-0002: an offline tap fails immediately — no call, no queue.
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.mark(
        venueId: venueId,
        partySize: partySize,
        identityPublic: identityPublic,
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
  Future<Either<Failure, Going>> update({
    required String venueId,
    int? partySize,
    bool? identityPublic,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.update(
        venueId: venueId,
        partySize: partySize,
        identityPublic: identityPublic,
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
  Future<Either<Failure, OwnerGoingSummary>> getOwnerSummary(
    String venueId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await _remote.getOwnerSummary(venueId);
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
