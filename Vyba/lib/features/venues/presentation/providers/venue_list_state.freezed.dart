// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VenueListState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VenueListState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VenueListState()';
  }
}

/// @nodoc
class $VenueListStateCopyWith<$Res> {
  $VenueListStateCopyWith(VenueListState _, $Res Function(VenueListState) __);
}

/// @nodoc

class VenueListInitial implements VenueListState {
  const VenueListInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VenueListInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VenueListState.initial()';
  }
}

/// @nodoc

class VenueListLoading implements VenueListState {
  const VenueListLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is VenueListLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'VenueListState.loading()';
  }
}

/// @nodoc

class VenueListLoaded implements VenueListState {
  const VenueListLoaded(
      {required final List<Venue> venues,
      this.hasMore = false,
      this.filter = const VenueFilter()})
      : _venues = venues;

  final List<Venue> _venues;
  List<Venue> get venues {
    if (_venues is EqualUnmodifiableListView) return _venues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venues);
  }

  @JsonKey()
  final bool hasMore;
  @JsonKey()
  final VenueFilter filter;

  /// Create a copy of VenueListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueListLoadedCopyWith<VenueListLoaded> get copyWith =>
      _$VenueListLoadedCopyWithImpl<VenueListLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueListLoaded &&
            const DeepCollectionEquality().equals(other._venues, _venues) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_venues), hasMore, filter);

  @override
  String toString() {
    return 'VenueListState.loaded(venues: $venues, hasMore: $hasMore, filter: $filter)';
  }
}

/// @nodoc
abstract mixin class $VenueListLoadedCopyWith<$Res>
    implements $VenueListStateCopyWith<$Res> {
  factory $VenueListLoadedCopyWith(
          VenueListLoaded value, $Res Function(VenueListLoaded) _then) =
      _$VenueListLoadedCopyWithImpl;
  @useResult
  $Res call({List<Venue> venues, bool hasMore, VenueFilter filter});
}

/// @nodoc
class _$VenueListLoadedCopyWithImpl<$Res>
    implements $VenueListLoadedCopyWith<$Res> {
  _$VenueListLoadedCopyWithImpl(this._self, this._then);

  final VenueListLoaded _self;
  final $Res Function(VenueListLoaded) _then;

  /// Create a copy of VenueListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? venues = null,
    Object? hasMore = null,
    Object? filter = null,
  }) {
    return _then(VenueListLoaded(
      venues: null == venues
          ? _self._venues
          : venues // ignore: cast_nullable_to_non_nullable
              as List<Venue>,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      filter: null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as VenueFilter,
    ));
  }
}

/// @nodoc

class VenueListError implements VenueListState {
  const VenueListError({required this.message});

  final String message;

  /// Create a copy of VenueListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueListErrorCopyWith<VenueListError> get copyWith =>
      _$VenueListErrorCopyWithImpl<VenueListError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueListError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'VenueListState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $VenueListErrorCopyWith<$Res>
    implements $VenueListStateCopyWith<$Res> {
  factory $VenueListErrorCopyWith(
          VenueListError value, $Res Function(VenueListError) _then) =
      _$VenueListErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$VenueListErrorCopyWithImpl<$Res>
    implements $VenueListErrorCopyWith<$Res> {
  _$VenueListErrorCopyWithImpl(this._self, this._then);

  final VenueListError _self;
  final $Res Function(VenueListError) _then;

  /// Create a copy of VenueListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(VenueListError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
