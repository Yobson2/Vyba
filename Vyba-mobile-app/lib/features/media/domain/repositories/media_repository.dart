import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/media/domain/entities/venue_night_photo.dart';

abstract class MediaRepository {
  /// Adds a photo to [venueId] for tonight. Visible on the night view right
  /// away; may or may not be promoted into the main feed (spec 06).
  Future<Either<Failure, VenueNightPhoto>> uploadVenueNightPhoto({
    required String venueId,
    required String filePath,
  });

  Future<Either<Failure, List<VenueNightPhoto>>> getVenueNightPhotos(
    String venueId,
  );
}
