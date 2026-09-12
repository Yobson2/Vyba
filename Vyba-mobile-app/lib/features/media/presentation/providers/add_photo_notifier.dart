import 'package:flutter_templates/features/media/domain/usecases/upload_venue_night_photo_usecase.dart';
import 'package:flutter_templates/features/media/presentation/providers/add_photo_state.dart';
import 'package:flutter_templates/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_templates/features/media/presentation/providers/venue_night_photos_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_photo_notifier.g.dart';

/// "Ajouter une photo" for one venue (ticket 14) — on success, refreshes
/// [venueNightPhotosProvider] for the same venue so it shows immediately.
@riverpod
class AddPhotoNotifier extends _$AddPhotoNotifier {
  @override
  AddPhotoState build(String venueId) => const AddPhotoState.idle();

  Future<void> upload(String filePath) async {
    state = const AddPhotoState.uploading();
    final result = await ref.read(uploadVenueNightPhotoUseCaseProvider).call(
          UploadVenueNightPhotoParams(venueId: venueId, filePath: filePath),
        );
    result.fold(
      (failure) => state = AddPhotoState.error(failure.message),
      (_) {
        state = const AddPhotoState.success();
        if (ref.exists(venueNightPhotosProvider(venueId))) {
          ref.invalidate(venueNightPhotosProvider(venueId));
        }
      },
    );
  }

  void reset() => state = const AddPhotoState.idle();
}
