import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/services/location_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

/// Provides the [LocationService] instance.
@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  return GeolocatorLocationService();
}
