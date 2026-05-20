// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotesState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NotesState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NotesState()';
  }
}

/// @nodoc
class $NotesStateCopyWith<$Res> {
  $NotesStateCopyWith(NotesState _, $Res Function(NotesState) __);
}

/// @nodoc

class NotesInitial implements NotesState {
  const NotesInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NotesInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NotesState.initial()';
  }
}

/// @nodoc

class NotesLoading implements NotesState {
  const NotesLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NotesLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NotesState.loading()';
  }
}

/// @nodoc

class NotesSuccess implements NotesState {
  const NotesSuccess({this.message});

  final String? message;

  /// Create a copy of NotesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotesSuccessCopyWith<NotesSuccess> get copyWith =>
      _$NotesSuccessCopyWithImpl<NotesSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotesSuccess &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'NotesState.success(message: $message)';
  }
}

/// @nodoc
abstract mixin class $NotesSuccessCopyWith<$Res>
    implements $NotesStateCopyWith<$Res> {
  factory $NotesSuccessCopyWith(
          NotesSuccess value, $Res Function(NotesSuccess) _then) =
      _$NotesSuccessCopyWithImpl;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class _$NotesSuccessCopyWithImpl<$Res> implements $NotesSuccessCopyWith<$Res> {
  _$NotesSuccessCopyWithImpl(this._self, this._then);

  final NotesSuccess _self;
  final $Res Function(NotesSuccess) _then;

  /// Create a copy of NotesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
  }) {
    return _then(NotesSuccess(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class NotesLoaded implements NotesState {
  const NotesLoaded(this.note);

  final Note note;

  /// Create a copy of NotesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotesLoadedCopyWith<NotesLoaded> get copyWith =>
      _$NotesLoadedCopyWithImpl<NotesLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotesLoaded &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(runtimeType, note);

  @override
  String toString() {
    return 'NotesState.loaded(note: $note)';
  }
}

/// @nodoc
abstract mixin class $NotesLoadedCopyWith<$Res>
    implements $NotesStateCopyWith<$Res> {
  factory $NotesLoadedCopyWith(
          NotesLoaded value, $Res Function(NotesLoaded) _then) =
      _$NotesLoadedCopyWithImpl;
  @useResult
  $Res call({Note note});
}

/// @nodoc
class _$NotesLoadedCopyWithImpl<$Res> implements $NotesLoadedCopyWith<$Res> {
  _$NotesLoadedCopyWithImpl(this._self, this._then);

  final NotesLoaded _self;
  final $Res Function(NotesLoaded) _then;

  /// Create a copy of NotesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? note = null,
  }) {
    return _then(NotesLoaded(
      null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as Note,
    ));
  }
}

/// @nodoc

class NotesError implements NotesState {
  const NotesError(this.message);

  final String message;

  /// Create a copy of NotesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotesErrorCopyWith<NotesError> get copyWith =>
      _$NotesErrorCopyWithImpl<NotesError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotesError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'NotesState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $NotesErrorCopyWith<$Res>
    implements $NotesStateCopyWith<$Res> {
  factory $NotesErrorCopyWith(
          NotesError value, $Res Function(NotesError) _then) =
      _$NotesErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$NotesErrorCopyWithImpl<$Res> implements $NotesErrorCopyWith<$Res> {
  _$NotesErrorCopyWithImpl(this._self, this._then);

  final NotesError _self;
  final $Res Function(NotesError) _then;

  /// Create a copy of NotesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(NotesError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
