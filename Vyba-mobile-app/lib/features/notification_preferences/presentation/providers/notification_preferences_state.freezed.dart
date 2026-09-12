// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferencesState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationPreferencesState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NotificationPreferencesState()';
  }
}

/// @nodoc
class $NotificationPreferencesStateCopyWith<$Res> {
  $NotificationPreferencesStateCopyWith(NotificationPreferencesState _,
      $Res Function(NotificationPreferencesState) __);
}

/// @nodoc

class NotificationPreferencesLoading implements NotificationPreferencesState {
  const NotificationPreferencesLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationPreferencesLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NotificationPreferencesState.loading()';
  }
}

/// @nodoc

class NotificationPreferencesLoaded implements NotificationPreferencesState {
  const NotificationPreferencesLoaded(this.preferences);

  final NotificationPreferences preferences;

  /// Create a copy of NotificationPreferencesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationPreferencesLoadedCopyWith<NotificationPreferencesLoaded>
      get copyWith => _$NotificationPreferencesLoadedCopyWithImpl<
          NotificationPreferencesLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationPreferencesLoaded &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences));
  }

  @override
  int get hashCode => Object.hash(runtimeType, preferences);

  @override
  String toString() {
    return 'NotificationPreferencesState.loaded(preferences: $preferences)';
  }
}

/// @nodoc
abstract mixin class $NotificationPreferencesLoadedCopyWith<$Res>
    implements $NotificationPreferencesStateCopyWith<$Res> {
  factory $NotificationPreferencesLoadedCopyWith(
          NotificationPreferencesLoaded value,
          $Res Function(NotificationPreferencesLoaded) _then) =
      _$NotificationPreferencesLoadedCopyWithImpl;
  @useResult
  $Res call({NotificationPreferences preferences});
}

/// @nodoc
class _$NotificationPreferencesLoadedCopyWithImpl<$Res>
    implements $NotificationPreferencesLoadedCopyWith<$Res> {
  _$NotificationPreferencesLoadedCopyWithImpl(this._self, this._then);

  final NotificationPreferencesLoaded _self;
  final $Res Function(NotificationPreferencesLoaded) _then;

  /// Create a copy of NotificationPreferencesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? preferences = null,
  }) {
    return _then(NotificationPreferencesLoaded(
      null == preferences
          ? _self.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as NotificationPreferences,
    ));
  }
}

/// @nodoc

class NotificationPreferencesError implements NotificationPreferencesState {
  const NotificationPreferencesError(this.message);

  final String message;

  /// Create a copy of NotificationPreferencesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationPreferencesErrorCopyWith<NotificationPreferencesError>
      get copyWith => _$NotificationPreferencesErrorCopyWithImpl<
          NotificationPreferencesError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationPreferencesError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'NotificationPreferencesState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $NotificationPreferencesErrorCopyWith<$Res>
    implements $NotificationPreferencesStateCopyWith<$Res> {
  factory $NotificationPreferencesErrorCopyWith(
          NotificationPreferencesError value,
          $Res Function(NotificationPreferencesError) _then) =
      _$NotificationPreferencesErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$NotificationPreferencesErrorCopyWithImpl<$Res>
    implements $NotificationPreferencesErrorCopyWith<$Res> {
  _$NotificationPreferencesErrorCopyWithImpl(this._self, this._then);

  final NotificationPreferencesError _self;
  final $Res Function(NotificationPreferencesError) _then;

  /// Create a copy of NotificationPreferencesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(NotificationPreferencesError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
