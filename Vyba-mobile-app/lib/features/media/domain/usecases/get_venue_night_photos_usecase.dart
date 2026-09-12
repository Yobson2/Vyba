import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/media/domain/entities/venue_night_photo.dart';
import 'package:flutter_templates/features/media/domain/repositories/media_repository.dart';

class GetVenueNightPhotosUseCase
    extends UseCase<List<VenueNightPhoto>, String> {
  const GetVenueNightPhotosUseCase(this._repository);

  final MediaRepository _repository;

  @override
  Future<Either<Failure, List<VenueNightPhoto>>> call(String venueId) {
    return _repository.getVenueNightPhotos(venueId);
  }
}
