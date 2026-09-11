import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/venues/data/datasources/venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_filter.dart';
import 'package:flutter_templates/features/venues/domain/repositories/venue_repository.dart';

class VenueRepositoryImpl implements VenueRepository {
  VenueRepositoryImpl(this._remoteDataSource);

  final VenueRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Venue>>> getVenues({
    VenueFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDataSource.getVenues(
        page: page,
        limit: limit,
      );
      final venues = models.map((m) => m.toEntity()).toList();
      return Right(venues);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Venue>> getVenueById(String id) async {
    try {
      final model = await _remoteDataSource.getVenueById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Venue>>> searchVenues(String query) async {
    try {
      final models = await _remoteDataSource.searchVenues(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
