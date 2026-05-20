// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VenueDetailState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VenueDetailState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VenueDetailState()';
  }
}

/// @nodoc
class $VenueDetailStateCopyWith<$Res> {
  $VenueDetailStateCopyWith(
      VenueDetailState _, $Res Function(VenueDetailState) __);
}

/// @nodoc

class VenueDetailLoading implements VenueDetailState {
  const VenueDetailLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VenueDetailLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VenueDetailState.loading()';
  }
}

/// @nodoc

class VenueDetailLoaded implements VenueDetailState {
  const VenueDetailLoaded({required this.venue});

  final Venue venue;

  /// Create a copy of VenueDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueDetailLoadedCopyWith<VenueDetailLoaded> get copyWith =>
      _$VenueDetailLoadedCopyWithImpl<VenueDetailLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueDetailLoaded &&
            (identical(other.venue, venue) || other.venue == venue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, venue);

  @override
  String toString() {
    return 'VenueDetailState.loaded(venue: $venue)';
  }
}

/// @nodoc
abstract mixin class $VenueDetailLoadedCopyWith<$Res>
    implements $VenueDetailStateCopyWith<$Res> {
  factory $VenueDetailLoadedCopyWith(
          VenueDetailLoaded value, $Res Function(VenueDetailLoaded) _then) =
      _$VenueDetailLoadedCopyWithImpl;
  @useResult
  $Res call({Venue venue});
}

/// @nodoc
class _$VenueDetailLoadedCopyWithImpl<$Res>
    implements $VenueDetailLoadedCopyWith<$Res> {
  _$VenueDetailLoadedCopyWithImpl(this._self, this._then);

  final VenueDetailLoaded _self;
  final $Res Function(VenueDetailLoaded) _then;

  /// Create a copy of VenueDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? venue = null,
  }) {
    return _then(VenueDetailLoaded(
      venue: null == venue
          ? _self.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as Venue,
    ));
  }
}

/// @nodoc

class VenueDetailError implements VenueDetailState {
  const VenueDetailError({required this.message});

  final String message;

  /// Create a copy of VenueDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueDetailErrorCopyWith<VenueDetailError> get copyWith =>
      _$VenueDetailErrorCopyWithImpl<VenueDetailError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueDetailError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'VenueDetailState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $VenueDetailErrorCopyWith<$Res>
    implements $VenueDetailStateCopyWith<$Res> {
  factory $VenueDetailErrorCopyWith(
          VenueDetailError value, $Res Function(VenueDetailError) _then) =
      _$VenueDetailErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$VenueDetailErrorCopyWithImpl<$Res>
    implements $VenueDetailErrorCopyWith<$Res> {
  _$VenueDetailErrorCopyWithImpl(this._self, this._then);

  final VenueDetailError _self;
  final $Res Function(VenueDetailError) _then;

  /// Create a copy of VenueDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(VenueDetailError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
