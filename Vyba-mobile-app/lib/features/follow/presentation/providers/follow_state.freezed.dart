// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FollowState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FollowState()';
  }
}

/// @nodoc
class $FollowStateCopyWith<$Res> {
  $FollowStateCopyWith(FollowState _, $Res Function(FollowState) __);
}

/// @nodoc

class FollowLoading implements FollowState {
  const FollowLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FollowLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FollowState.loading()';
  }
}

/// @nodoc

class FollowNotFollowing implements FollowState {
  const FollowNotFollowing();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FollowNotFollowing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FollowState.notFollowing()';
  }
}

/// @nodoc

class FollowFollowing implements FollowState {
  const FollowFollowing();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FollowFollowing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FollowState.following()';
  }
}

/// @nodoc

class FollowErrorState implements FollowState {
  const FollowErrorState(this.message);

  final String message;

  /// Create a copy of FollowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FollowErrorStateCopyWith<FollowErrorState> get copyWith =>
      _$FollowErrorStateCopyWithImpl<FollowErrorState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FollowErrorState &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'FollowState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $FollowErrorStateCopyWith<$Res>
    implements $FollowStateCopyWith<$Res> {
  factory $FollowErrorStateCopyWith(
          FollowErrorState value, $Res Function(FollowErrorState) _then) =
      _$FollowErrorStateCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FollowErrorStateCopyWithImpl<$Res>
    implements $FollowErrorStateCopyWith<$Res> {
  _$FollowErrorStateCopyWithImpl(this._self, this._then);

  final FollowErrorState _self;
  final $Res Function(FollowErrorState) _then;

  /// Create a copy of FollowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(FollowErrorState(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
