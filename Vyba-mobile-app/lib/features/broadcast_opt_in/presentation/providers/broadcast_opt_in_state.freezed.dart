// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_opt_in_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BroadcastOptInState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BroadcastOptInState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BroadcastOptInState()';
  }
}

/// @nodoc
class $BroadcastOptInStateCopyWith<$Res> {
  $BroadcastOptInStateCopyWith(
      BroadcastOptInState _, $Res Function(BroadcastOptInState) __);
}

/// @nodoc

class BroadcastOptInLoading implements BroadcastOptInState {
  const BroadcastOptInLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BroadcastOptInLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BroadcastOptInState.loading()';
  }
}

/// @nodoc

class BroadcastOptedOut implements BroadcastOptInState {
  const BroadcastOptedOut();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BroadcastOptedOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BroadcastOptInState.optedOut()';
  }
}

/// @nodoc

class BroadcastOptedIn implements BroadcastOptInState {
  const BroadcastOptedIn();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BroadcastOptedIn);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BroadcastOptInState.optedIn()';
  }
}

/// @nodoc

class BroadcastOptInError implements BroadcastOptInState {
  const BroadcastOptInError(this.message);

  final String message;

  /// Create a copy of BroadcastOptInState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BroadcastOptInErrorCopyWith<BroadcastOptInError> get copyWith =>
      _$BroadcastOptInErrorCopyWithImpl<BroadcastOptInError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BroadcastOptInError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'BroadcastOptInState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $BroadcastOptInErrorCopyWith<$Res>
    implements $BroadcastOptInStateCopyWith<$Res> {
  factory $BroadcastOptInErrorCopyWith(
          BroadcastOptInError value, $Res Function(BroadcastOptInError) _then) =
      _$BroadcastOptInErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$BroadcastOptInErrorCopyWithImpl<$Res>
    implements $BroadcastOptInErrorCopyWith<$Res> {
  _$BroadcastOptInErrorCopyWithImpl(this._self, this._then);

  final BroadcastOptInError _self;
  final $Res Function(BroadcastOptInError) _then;

  /// Create a copy of BroadcastOptInState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(BroadcastOptInError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
