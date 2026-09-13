import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:geolocator/geolocator.dart';

/// Abstract location-lookup interface — the "search near me" primitive.
///
/// Never returns a silent null on denial: permission/service failures are
/// surfaced as a [LocationFailure] so callers can show the user why nearby
/// search didn't run.
abstract class LocationService {
  /// The device's current position, requesting permission if needed.
  Future<Either<Failure, Position>> getCurrentPosition();
}

/// [Geolocator]-backed [LocationService].
class GeolocatorLocationService implements LocationService {
  @override
  Future<Either<Failure, Position>> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const Left(
        LocationFailure(message: 'Le service de localisation est désactivé'),
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return const Left(
        LocationFailure(message: 'Accès à la localisation refusé'),
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      return Right(position);
    } catch (_) {
      return const Left(LocationFailure());
    }
  }
}
