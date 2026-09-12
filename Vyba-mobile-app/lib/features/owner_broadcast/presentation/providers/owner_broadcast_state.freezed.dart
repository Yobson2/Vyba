// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_broadcast_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerBroadcastState {
  bool get submitting;
  bool get sent;
  bool get alreadySentTonight;
  String? get errorMessage;

  /// Create a copy of OwnerBroadcastState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OwnerBroadcastStateCopyWith<OwnerBroadcastState> get copyWith =>
      _$OwnerBroadcastStateCopyWithImpl<OwnerBroadcastState>(
          this as OwnerBroadcastState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OwnerBroadcastState &&
            (identical(other.submitting, submitting) ||
                other.submitting == submitting) &&
            (identical(other.sent, sent) || other.sent == sent) &&
            (identical(other.alreadySentTonight, alreadySentTonight) ||
                other.alreadySentTonight == alreadySentTonight) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, submitting, sent, alreadySentTonight, errorMessage);

  @override
  String toString() {
    return 'OwnerBroadcastState(submitting: $submitting, sent: $sent, alreadySentTonight: $alreadySentTonight, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $OwnerBroadcastStateCopyWith<$Res> {
  factory $OwnerBroadcastStateCopyWith(
          OwnerBroadcastState value, $Res Function(OwnerBroadcastState) _then) =
      _$OwnerBroadcastStateCopyWithImpl;
  @useResult
  $Res call(
      {bool submitting,
      bool sent,
      bool alreadySentTonight,
      String? errorMessage});
}

/// @nodoc
class _$OwnerBroadcastStateCopyWithImpl<$Res>
    implements $OwnerBroadcastStateCopyWith<$Res> {
  _$OwnerBroadcastStateCopyWithImpl(this._self, this._then);

  final OwnerBroadcastState _self;
  final $Res Function(OwnerBroadcastState) _then;

  /// Create a copy of OwnerBroadcastState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? submitting = null,
    Object? sent = null,
    Object? alreadySentTonight = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      submitting: null == submitting
          ? _self.submitting
          : submitting // ignore: cast_nullable_to_non_nullable
              as bool,
      sent: null == sent
          ? _self.sent
          : sent // ignore: cast_nullable_to_non_nullable
              as bool,
      alreadySentTonight: null == alreadySentTonight
          ? _self.alreadySentTonight
          : alreadySentTonight // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _OwnerBroadcastState implements OwnerBroadcastState {
  const _OwnerBroadcastState(
      {this.submitting = false,
      this.sent = false,
      this.alreadySentTonight = false,
      this.errorMessage});

  @override
  @JsonKey()
  final bool submitting;
  @override
  @JsonKey()
  final bool sent;
  @override
  @JsonKey()
  final bool alreadySentTonight;
  @override
  final String? errorMessage;

  /// Create a copy of OwnerBroadcastState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OwnerBroadcastStateCopyWith<_OwnerBroadcastState> get copyWith =>
      __$OwnerBroadcastStateCopyWithImpl<_OwnerBroadcastState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OwnerBroadcastState &&
            (identical(other.submitting, submitting) ||
                other.submitting == submitting) &&
            (identical(other.sent, sent) || other.sent == sent) &&
            (identical(other.alreadySentTonight, alreadySentTonight) ||
                other.alreadySentTonight == alreadySentTonight) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, submitting, sent, alreadySentTonight, errorMessage);

  @override
  String toString() {
    return 'OwnerBroadcastState(submitting: $submitting, sent: $sent, alreadySentTonight: $alreadySentTonight, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$OwnerBroadcastStateCopyWith<$Res>
    implements $OwnerBroadcastStateCopyWith<$Res> {
  factory _$OwnerBroadcastStateCopyWith(_OwnerBroadcastState value,
          $Res Function(_OwnerBroadcastState) _then) =
      __$OwnerBroadcastStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool submitting,
      bool sent,
      bool alreadySentTonight,
      String? errorMessage});
}

/// @nodoc
class __$OwnerBroadcastStateCopyWithImpl<$Res>
    implements _$OwnerBroadcastStateCopyWith<$Res> {
  __$OwnerBroadcastStateCopyWithImpl(this._self, this._then);

  final _OwnerBroadcastState _self;
  final $Res Function(_OwnerBroadcastState) _then;

  /// Create a copy of OwnerBroadcastState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? submitting = null,
    Object? sent = null,
    Object? alreadySentTonight = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_OwnerBroadcastState(
      submitting: null == submitting
          ? _self.submitting
          : submitting // ignore: cast_nullable_to_non_nullable
              as bool,
      sent: null == sent
          ? _self.sent
          : sent // ignore: cast_nullable_to_non_nullable
              as bool,
      alreadySentTonight: null == alreadySentTonight
          ? _self.alreadySentTonight
          : alreadySentTonight // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
