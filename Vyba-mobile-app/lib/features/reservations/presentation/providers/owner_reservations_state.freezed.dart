// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_reservations_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerReservationsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OwnerReservationsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OwnerReservationsState()';
  }
}

/// @nodoc
class $OwnerReservationsStateCopyWith<$Res> {
  $OwnerReservationsStateCopyWith(
      OwnerReservationsState _, $Res Function(OwnerReservationsState) __);
}

/// @nodoc

class OwnerReservationsLoading implements OwnerReservationsState {
  const OwnerReservationsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OwnerReservationsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OwnerReservationsState.loading()';
  }
}

/// @nodoc

class OwnerReservationsLoaded implements OwnerReservationsState {
  const OwnerReservationsLoaded(final List<Reservation> requests)
      : _requests = requests;

  final List<Reservation> _requests;
  List<Reservation> get requests {
    if (_requests is EqualUnmodifiableListView) return _requests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requests);
  }

  /// Create a copy of OwnerReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OwnerReservationsLoadedCopyWith<OwnerReservationsLoaded> get copyWith =>
      _$OwnerReservationsLoadedCopyWithImpl<OwnerReservationsLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OwnerReservationsLoaded &&
            const DeepCollectionEquality().equals(other._requests, _requests));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_requests));

  @override
  String toString() {
    return 'OwnerReservationsState.loaded(requests: $requests)';
  }
}

/// @nodoc
abstract mixin class $OwnerReservationsLoadedCopyWith<$Res>
    implements $OwnerReservationsStateCopyWith<$Res> {
  factory $OwnerReservationsLoadedCopyWith(OwnerReservationsLoaded value,
          $Res Function(OwnerReservationsLoaded) _then) =
      _$OwnerReservationsLoadedCopyWithImpl;
  @useResult
  $Res call({List<Reservation> requests});
}

/// @nodoc
class _$OwnerReservationsLoadedCopyWithImpl<$Res>
    implements $OwnerReservationsLoadedCopyWith<$Res> {
  _$OwnerReservationsLoadedCopyWithImpl(this._self, this._then);

  final OwnerReservationsLoaded _self;
  final $Res Function(OwnerReservationsLoaded) _then;

  /// Create a copy of OwnerReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requests = null,
  }) {
    return _then(OwnerReservationsLoaded(
      null == requests
          ? _self._requests
          : requests // ignore: cast_nullable_to_non_nullable
              as List<Reservation>,
    ));
  }
}

/// @nodoc

class OwnerReservationsError implements OwnerReservationsState {
  const OwnerReservationsError(this.message);

  final String message;

  /// Create a copy of OwnerReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OwnerReservationsErrorCopyWith<OwnerReservationsError> get copyWith =>
      _$OwnerReservationsErrorCopyWithImpl<OwnerReservationsError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OwnerReservationsError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'OwnerReservationsState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $OwnerReservationsErrorCopyWith<$Res>
    implements $OwnerReservationsStateCopyWith<$Res> {
  factory $OwnerReservationsErrorCopyWith(OwnerReservationsError value,
          $Res Function(OwnerReservationsError) _then) =
      _$OwnerReservationsErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$OwnerReservationsErrorCopyWithImpl<$Res>
    implements $OwnerReservationsErrorCopyWith<$Res> {
  _$OwnerReservationsErrorCopyWithImpl(this._self, this._then);

  final OwnerReservationsError _self;
  final $Res Function(OwnerReservationsError) _then;

  /// Create a copy of OwnerReservationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(OwnerReservationsError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
