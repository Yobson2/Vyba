import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/follow/data/datasources/follow_remote_datasource.dart';
import 'package:flutter_templates/features/follow/domain/entities/followed_venue.dart';
import 'package:flutter_templates/features/follow/domain/repositories/follow_repository.dart';

class FollowRepositoryImpl implements FollowRepository {
  const FollowRepositoryImpl({
    required FollowRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final FollowRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, bool>> isFollowing(String venueId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      return Right(await _remote.isFollowing(venueId));
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> follow(String venueId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.follow(venueId);
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
  Future<Either<Failure, void>> unfollow(String venueId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.unfollow(venueId);
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
  Future<Either<Failure, List<FollowedVenue>>> getMyFollowedVenues() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      return Right(await _remote.getMyFollowedVenues());
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
