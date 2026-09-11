// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'going_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoingState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GoingState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoingState()';
  }
}

/// @nodoc
class $GoingStateCopyWith<$Res> {
  $GoingStateCopyWith(GoingState _, $Res Function(GoingState) __);
}

/// @nodoc

class GoingLoading implements GoingState {
  const GoingLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GoingLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoingState.loading()';
  }
}

/// @nodoc

class GoingNotMarked implements GoingState {
  const GoingNotMarked();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GoingNotMarked);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoingState.notMarked()';
  }
}

/// @nodoc

class GoingMarked implements GoingState {
  const GoingMarked(this.going);

  final Going going;

  /// Create a copy of GoingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoingMarkedCopyWith<GoingMarked> get copyWith =>
      _$GoingMarkedCopyWithImpl<GoingMarked>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoingMarked &&
            (identical(other.going, going) || other.going == going));
  }

  @override
  int get hashCode => Object.hash(runtimeType, going);

  @override
  String toString() {
    return 'GoingState.marked(going: $going)';
  }
}

/// @nodoc
abstract mixin class $GoingMarkedCopyWith<$Res>
    implements $GoingStateCopyWith<$Res> {
  factory $GoingMarkedCopyWith(
          GoingMarked value, $Res Function(GoingMarked) _then) =
      _$GoingMarkedCopyWithImpl;
  @useResult
  $Res call({Going going});
}

/// @nodoc
class _$GoingMarkedCopyWithImpl<$Res> implements $GoingMarkedCopyWith<$Res> {
  _$GoingMarkedCopyWithImpl(this._self, this._then);

  final GoingMarked _self;
  final $Res Function(GoingMarked) _then;

  /// Create a copy of GoingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? going = null,
  }) {
    return _then(GoingMarked(
      null == going
          ? _self.going
          : going // ignore: cast_nullable_to_non_nullable
              as Going,
    ));
  }
}

/// @nodoc

class GoingOwnedVenue implements GoingState {
  const GoingOwnedVenue();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GoingOwnedVenue);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoingState.ownedVenue()';
  }
}

/// @nodoc

class GoingOffline implements GoingState {
  const GoingOffline();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GoingOffline);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoingState.offline()';
  }
}

/// @nodoc

class GoingErrorState implements GoingState {
  const GoingErrorState(this.message);

  final String message;

  /// Create a copy of GoingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoingErrorStateCopyWith<GoingErrorState> get copyWith =>
      _$GoingErrorStateCopyWithImpl<GoingErrorState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoingErrorState &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'GoingState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $GoingErrorStateCopyWith<$Res>
    implements $GoingStateCopyWith<$Res> {
  factory $GoingErrorStateCopyWith(
          GoingErrorState value, $Res Function(GoingErrorState) _then) =
      _$GoingErrorStateCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$GoingErrorStateCopyWithImpl<$Res>
    implements $GoingErrorStateCopyWith<$Res> {
  _$GoingErrorStateCopyWithImpl(this._self, this._then);

  final GoingErrorState _self;
  final $Res Function(GoingErrorState) _then;

  /// Create a copy of GoingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(GoingErrorState(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
