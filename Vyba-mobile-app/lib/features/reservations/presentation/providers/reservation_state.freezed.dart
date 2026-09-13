// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReservationState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReservationState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationState()';
  }
}

/// @nodoc
class $ReservationStateCopyWith<$Res> {
  $ReservationStateCopyWith(
      ReservationState _, $Res Function(ReservationState) __);
}

/// @nodoc

class ReservationLoading implements ReservationState {
  const ReservationLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReservationLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationState.loading()';
  }
}

/// @nodoc

class ReservationNotRequested implements ReservationState {
  const ReservationNotRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReservationNotRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationState.notRequested()';
  }
}

/// @nodoc

class ReservationPending implements ReservationState {
  const ReservationPending(this.reservation);

  final Reservation reservation;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationPendingCopyWith<ReservationPending> get copyWith =>
      _$ReservationPendingCopyWithImpl<ReservationPending>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationPending &&
            (identical(other.reservation, reservation) ||
                other.reservation == reservation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reservation);

  @override
  String toString() {
    return 'ReservationState.pending(reservation: $reservation)';
  }
}

/// @nodoc
abstract mixin class $ReservationPendingCopyWith<$Res>
    implements $ReservationStateCopyWith<$Res> {
  factory $ReservationPendingCopyWith(
          ReservationPending value, $Res Function(ReservationPending) _then) =
      _$ReservationPendingCopyWithImpl;
  @useResult
  $Res call({Reservation reservation});
}

/// @nodoc
class _$ReservationPendingCopyWithImpl<$Res>
    implements $ReservationPendingCopyWith<$Res> {
  _$ReservationPendingCopyWithImpl(this._self, this._then);

  final ReservationPending _self;
  final $Res Function(ReservationPending) _then;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reservation = null,
  }) {
    return _then(ReservationPending(
      null == reservation
          ? _self.reservation
          : reservation // ignore: cast_nullable_to_non_nullable
              as Reservation,
    ));
  }
}

/// @nodoc

class ReservationConfirmed implements ReservationState {
  const ReservationConfirmed(this.reservation);

  final Reservation reservation;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationConfirmedCopyWith<ReservationConfirmed> get copyWith =>
      _$ReservationConfirmedCopyWithImpl<ReservationConfirmed>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationConfirmed &&
            (identical(other.reservation, reservation) ||
                other.reservation == reservation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reservation);

  @override
  String toString() {
    return 'ReservationState.confirmed(reservation: $reservation)';
  }
}

/// @nodoc
abstract mixin class $ReservationConfirmedCopyWith<$Res>
    implements $ReservationStateCopyWith<$Res> {
  factory $ReservationConfirmedCopyWith(ReservationConfirmed value,
          $Res Function(ReservationConfirmed) _then) =
      _$ReservationConfirmedCopyWithImpl;
  @useResult
  $Res call({Reservation reservation});
}

/// @nodoc
class _$ReservationConfirmedCopyWithImpl<$Res>
    implements $ReservationConfirmedCopyWith<$Res> {
  _$ReservationConfirmedCopyWithImpl(this._self, this._then);

  final ReservationConfirmed _self;
  final $Res Function(ReservationConfirmed) _then;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reservation = null,
  }) {
    return _then(ReservationConfirmed(
      null == reservation
          ? _self.reservation
          : reservation // ignore: cast_nullable_to_non_nullable
              as Reservation,
    ));
  }
}

/// @nodoc

class ReservationOwnedVenue implements ReservationState {
  const ReservationOwnedVenue();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReservationOwnedVenue);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationState.ownedVenue()';
  }
}

/// @nodoc

class ReservationOffline implements ReservationState {
  const ReservationOffline();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReservationOffline);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationState.offline()';
  }
}

/// @nodoc

class ReservationErrorState implements ReservationState {
  const ReservationErrorState(this.message);

  final String message;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationErrorStateCopyWith<ReservationErrorState> get copyWith =>
      _$ReservationErrorStateCopyWithImpl<ReservationErrorState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationErrorState &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ReservationState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ReservationErrorStateCopyWith<$Res>
    implements $ReservationStateCopyWith<$Res> {
  factory $ReservationErrorStateCopyWith(ReservationErrorState value,
          $Res Function(ReservationErrorState) _then) =
      _$ReservationErrorStateCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ReservationErrorStateCopyWithImpl<$Res>
    implements $ReservationErrorStateCopyWith<$Res> {
  _$ReservationErrorStateCopyWithImpl(this._self, this._then);

  final ReservationErrorState _self;
  final $Res Function(ReservationErrorState) _then;

  /// Create a copy of ReservationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ReservationErrorState(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
