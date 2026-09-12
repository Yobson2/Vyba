// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_photo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddPhotoState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddPhotoState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddPhotoState()';
  }
}

/// @nodoc
class $AddPhotoStateCopyWith<$Res> {
  $AddPhotoStateCopyWith(AddPhotoState _, $Res Function(AddPhotoState) __);
}

/// @nodoc

class AddPhotoIdle implements AddPhotoState {
  const AddPhotoIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddPhotoIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddPhotoState.idle()';
  }
}

/// @nodoc

class AddPhotoUploading implements AddPhotoState {
  const AddPhotoUploading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddPhotoUploading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddPhotoState.uploading()';
  }
}

/// @nodoc

class AddPhotoSuccess implements AddPhotoState {
  const AddPhotoSuccess();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AddPhotoSuccess);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AddPhotoState.success()';
  }
}

/// @nodoc

class AddPhotoError implements AddPhotoState {
  const AddPhotoError(this.message);

  final String message;

  /// Create a copy of AddPhotoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddPhotoErrorCopyWith<AddPhotoError> get copyWith =>
      _$AddPhotoErrorCopyWithImpl<AddPhotoError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddPhotoError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AddPhotoState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AddPhotoErrorCopyWith<$Res>
    implements $AddPhotoStateCopyWith<$Res> {
  factory $AddPhotoErrorCopyWith(
          AddPhotoError value, $Res Function(AddPhotoError) _then) =
      _$AddPhotoErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AddPhotoErrorCopyWithImpl<$Res>
    implements $AddPhotoErrorCopyWith<$Res> {
  _$AddPhotoErrorCopyWithImpl(this._self, this._then);

  final AddPhotoError _self;
  final $Res Function(AddPhotoError) _then;

  /// Create a copy of AddPhotoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(AddPhotoError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
