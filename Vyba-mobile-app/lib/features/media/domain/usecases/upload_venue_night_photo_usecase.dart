import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/media/domain/entities/venue_night_photo.dart';
import 'package:flutter_templates/features/media/domain/repositories/media_repository.dart';

@immutable
class UploadVenueNightPhotoParams {
  const UploadVenueNightPhotoParams({
    required this.venueId,
    required this.filePath,
  });

  final String venueId;
  final String filePath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadVenueNightPhotoParams &&
          runtimeType == other.runtimeType &&
          venueId == other.venueId &&
          filePath == other.filePath;

  @override
  int get hashCode => Object.hash(venueId, filePath);
}

class UploadVenueNightPhotoUseCase
    extends UseCase<VenueNightPhoto, UploadVenueNightPhotoParams> {
  const UploadVenueNightPhotoUseCase(this._repository);

  final MediaRepository _repository;

  @override
  Future<Either<Failure, VenueNightPhoto>> call(
    UploadVenueNightPhotoParams params,
  ) {
    return _repository.uploadVenueNightPhoto(
      venueId: params.venueId,
      filePath: params.filePath,
    );
  }
}
