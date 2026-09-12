import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/broadcast_opt_in/data/datasources/broadcast_opt_in_remote_datasource.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/entities/opted_in_venue.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/repositories/broadcast_opt_in_repository.dart';

class BroadcastOptInRepositoryImpl implements BroadcastOptInRepository {
  const BroadcastOptInRepositoryImpl({
    required BroadcastOptInRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final BroadcastOptInRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, bool>> isOptedIn(String venueId) {
    return _guarded(() => _remote.isOptedIn(venueId));
  }

  @override
  Future<Either<Failure, void>> optIn(String venueId) {
    return _guarded(() => _remote.optIn(venueId));
  }

  @override
  Future<Either<Failure, void>> optOut(String venueId) {
    return _guarded(() => _remote.optOut(venueId));
  }

  @override
  Future<Either<Failure, List<OptedInVenue>>> getMyOptIns() {
    return _guarded(_remote.getMyOptIns);
  }

  Future<Either<Failure, T>> _guarded<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          code: e.code,
        ),
      );
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
