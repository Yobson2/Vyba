import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_photo_state.freezed.dart';

/// "Ajouter une photo" upload flow for one venue (ticket 14).
@freezed
sealed class AddPhotoState with _$AddPhotoState {
  const factory AddPhotoState.idle() = AddPhotoIdle;
  const factory AddPhotoState.uploading() = AddPhotoUploading;
  const factory AddPhotoState.success() = AddPhotoSuccess;
  const factory AddPhotoState.error(String message) = AddPhotoError;
}
