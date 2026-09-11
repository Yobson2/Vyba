// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_night_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VenueNightState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VenueNightState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VenueNightState()';
  }
}

/// @nodoc
class $VenueNightStateCopyWith<$Res> {
  $VenueNightStateCopyWith(
      VenueNightState _, $Res Function(VenueNightState) __);
}

/// @nodoc

class VenueNightLoading implements VenueNightState {
  const VenueNightLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VenueNightLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VenueNightState.loading()';
  }
}

/// @nodoc

class VenueNightLoaded implements VenueNightState {
  const VenueNightLoaded({required this.venue, required this.tonight});

  final OwnerVenue venue;
  final VenueTonight tonight;

  /// Create a copy of VenueNightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueNightLoadedCopyWith<VenueNightLoaded> get copyWith =>
      _$VenueNightLoadedCopyWithImpl<VenueNightLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueNightLoaded &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.tonight, tonight) || other.tonight == tonight));
  }

  @override
  int get hashCode => Object.hash(runtimeType, venue, tonight);

  @override
  String toString() {
    return 'VenueNightState.loaded(venue: $venue, tonight: $tonight)';
  }
}

/// @nodoc
abstract mixin class $VenueNightLoadedCopyWith<$Res>
    implements $VenueNightStateCopyWith<$Res> {
  factory $VenueNightLoadedCopyWith(
          VenueNightLoaded value, $Res Function(VenueNightLoaded) _then) =
      _$VenueNightLoadedCopyWithImpl;
  @useResult
  $Res call({OwnerVenue venue, VenueTonight tonight});
}

/// @nodoc
class _$VenueNightLoadedCopyWithImpl<$Res>
    implements $VenueNightLoadedCopyWith<$Res> {
  _$VenueNightLoadedCopyWithImpl(this._self, this._then);

  final VenueNightLoaded _self;
  final $Res Function(VenueNightLoaded) _then;

  /// Create a copy of VenueNightState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? venue = null,
    Object? tonight = null,
  }) {
    return _then(VenueNightLoaded(
      venue: null == venue
          ? _self.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as OwnerVenue,
      tonight: null == tonight
          ? _self.tonight
          : tonight // ignore: cast_nullable_to_non_nullable
              as VenueTonight,
    ));
  }
}

/// @nodoc

class VenueNightError implements VenueNightState {
  const VenueNightError({required this.message});

  final String message;

  /// Create a copy of VenueNightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueNightErrorCopyWith<VenueNightError> get copyWith =>
      _$VenueNightErrorCopyWithImpl<VenueNightError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueNightError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'VenueNightState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $VenueNightErrorCopyWith<$Res>
    implements $VenueNightStateCopyWith<$Res> {
  factory $VenueNightErrorCopyWith(
          VenueNightError value, $Res Function(VenueNightError) _then) =
      _$VenueNightErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$VenueNightErrorCopyWithImpl<$Res>
    implements $VenueNightErrorCopyWith<$Res> {
  _$VenueNightErrorCopyWithImpl(this._self, this._then);

  final VenueNightError _self;
  final $Res Function(VenueNightError) _then;

  /// Create a copy of VenueNightState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(VenueNightError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
