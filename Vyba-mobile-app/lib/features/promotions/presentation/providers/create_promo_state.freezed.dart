// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_promo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePromoState {
  bool get submitting;
  String? get errorMessage;
  Promo? get lastPublished;

  /// Create a copy of CreatePromoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreatePromoStateCopyWith<CreatePromoState> get copyWith =>
      _$CreatePromoStateCopyWithImpl<CreatePromoState>(
          this as CreatePromoState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreatePromoState &&
            (identical(other.submitting, submitting) ||
                other.submitting == submitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.lastPublished, lastPublished) ||
                other.lastPublished == lastPublished));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, submitting, errorMessage, lastPublished);

  @override
  String toString() {
    return 'CreatePromoState(submitting: $submitting, errorMessage: $errorMessage, lastPublished: $lastPublished)';
  }
}

/// @nodoc
abstract mixin class $CreatePromoStateCopyWith<$Res> {
  factory $CreatePromoStateCopyWith(
          CreatePromoState value, $Res Function(CreatePromoState) _then) =
      _$CreatePromoStateCopyWithImpl;
  @useResult
  $Res call({bool submitting, String? errorMessage, Promo? lastPublished});
}

/// @nodoc
class _$CreatePromoStateCopyWithImpl<$Res>
    implements $CreatePromoStateCopyWith<$Res> {
  _$CreatePromoStateCopyWithImpl(this._self, this._then);

  final CreatePromoState _self;
  final $Res Function(CreatePromoState) _then;

  /// Create a copy of CreatePromoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? submitting = null,
    Object? errorMessage = freezed,
    Object? lastPublished = freezed,
  }) {
    return _then(_self.copyWith(
      submitting: null == submitting
          ? _self.submitting
          : submitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPublished: freezed == lastPublished
          ? _self.lastPublished
          : lastPublished // ignore: cast_nullable_to_non_nullable
              as Promo?,
    ));
  }
}

/// @nodoc

class _CreatePromoState implements CreatePromoState {
  const _CreatePromoState(
      {this.submitting = false, this.errorMessage, this.lastPublished});

  @override
  @JsonKey()
  final bool submitting;
  @override
  final String? errorMessage;
  @override
  final Promo? lastPublished;

  /// Create a copy of CreatePromoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreatePromoStateCopyWith<_CreatePromoState> get copyWith =>
      __$CreatePromoStateCopyWithImpl<_CreatePromoState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreatePromoState &&
            (identical(other.submitting, submitting) ||
                other.submitting == submitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.lastPublished, lastPublished) ||
                other.lastPublished == lastPublished));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, submitting, errorMessage, lastPublished);

  @override
  String toString() {
    return 'CreatePromoState(submitting: $submitting, errorMessage: $errorMessage, lastPublished: $lastPublished)';
  }
}

/// @nodoc
abstract mixin class _$CreatePromoStateCopyWith<$Res>
    implements $CreatePromoStateCopyWith<$Res> {
  factory _$CreatePromoStateCopyWith(
          _CreatePromoState value, $Res Function(_CreatePromoState) _then) =
      __$CreatePromoStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool submitting, String? errorMessage, Promo? lastPublished});
}

/// @nodoc
class __$CreatePromoStateCopyWithImpl<$Res>
    implements _$CreatePromoStateCopyWith<$Res> {
  __$CreatePromoStateCopyWithImpl(this._self, this._then);

  final _CreatePromoState _self;
  final $Res Function(_CreatePromoState) _then;

  /// Create a copy of CreatePromoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? submitting = null,
    Object? errorMessage = freezed,
    Object? lastPublished = freezed,
  }) {
    return _then(_CreatePromoState(
      submitting: null == submitting
          ? _self.submitting
          : submitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPublished: freezed == lastPublished
          ? _self.lastPublished
          : lastPublished // ignore: cast_nullable_to_non_nullable
              as Promo?,
    ));
  }
}

// dart format on
