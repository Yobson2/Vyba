import 'package:flutter_templates/features/media/domain/entities/venue_night_photo.dart';
import 'package:flutter_templates/features/media/presentation/providers/media_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_night_photos_provider.g.dart';

/// Tonight's active user photos for a venue — the venue/night view seam
/// (ticket 14). Refetched after a successful upload via `AddPhotoNotifier`.
@riverpod
Future<List<VenueNightPhoto>> venueNightPhotos(
  VenueNightPhotosRef ref,
  String venueId,
) async {
  final result =
      await ref.read(getVenueNightPhotosUseCaseProvider).call(venueId);
  return result.fold((failure) => const [], (photos) => photos);
}
