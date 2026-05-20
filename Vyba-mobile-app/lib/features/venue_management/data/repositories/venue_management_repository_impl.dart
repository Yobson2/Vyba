import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/venue_management/data/datasources/mock_venue_management_datasource.dart';
import 'package:flutter_templates/features/venue_management/domain/entities/venue_profile.dart';
import 'package:flutter_templates/features/venue_management/domain/repositories/venue_management_repository.dart';

class VenueManagementRepositoryImpl implements VenueManagementRepository {
  VenueManagementRepositoryImpl(this._dataSource);

  final VenueManagementDataSource _dataSource;

  @override
  Future<Either<Failure, List<VenueProfile>>> getMyVenues() async {
    try {
      final venues = await _dataSource.getMyVenues();
      return Right(venues);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VenueProfile>> updateVenueProfile(
    VenueProfile venue,
  ) async {
    try {
      final updated = await _dataSource.updateVenueProfile(venue);
      return Right(updated);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
