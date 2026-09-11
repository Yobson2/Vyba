// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FeedState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FeedState()';
  }
}

/// @nodoc
class $FeedStateCopyWith<$Res> {
  $FeedStateCopyWith(FeedState _, $Res Function(FeedState) __);
}

/// @nodoc

class FeedLoading implements FeedState {
  const FeedLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FeedLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FeedState.loading()';
  }
}

/// @nodoc

class FeedLoaded implements FeedState {
  const FeedLoaded(
      {required final List<FeedItem> items,
      required this.isFromCache,
      required this.hasMore,
      this.isLoadingMore = false})
      : _items = items;

  final List<FeedItem> _items;
  List<FeedItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final bool isFromCache;
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedLoadedCopyWith<FeedLoaded> get copyWith =>
      _$FeedLoadedCopyWithImpl<FeedLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedLoaded &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isFromCache, isFromCache) ||
                other.isFromCache == isFromCache) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      isFromCache,
      hasMore,
      isLoadingMore);

  @override
  String toString() {
    return 'FeedState.loaded(items: $items, isFromCache: $isFromCache, hasMore: $hasMore, isLoadingMore: $isLoadingMore)';
  }
}

/// @nodoc
abstract mixin class $FeedLoadedCopyWith<$Res>
    implements $FeedStateCopyWith<$Res> {
  factory $FeedLoadedCopyWith(
          FeedLoaded value, $Res Function(FeedLoaded) _then) =
      _$FeedLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<FeedItem> items,
      bool isFromCache,
      bool hasMore,
      bool isLoadingMore});
}

/// @nodoc
class _$FeedLoadedCopyWithImpl<$Res> implements $FeedLoadedCopyWith<$Res> {
  _$FeedLoadedCopyWithImpl(this._self, this._then);

  final FeedLoaded _self;
  final $Res Function(FeedLoaded) _then;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? isFromCache = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
  }) {
    return _then(FeedLoaded(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FeedItem>,
      isFromCache: null == isFromCache
          ? _self.isFromCache
          : isFromCache // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class FeedError implements FeedState {
  const FeedError({required this.message});

  final String message;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedErrorCopyWith<FeedError> get copyWith =>
      _$FeedErrorCopyWithImpl<FeedError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'FeedState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $FeedErrorCopyWith<$Res>
    implements $FeedStateCopyWith<$Res> {
  factory $FeedErrorCopyWith(FeedError value, $Res Function(FeedError) _then) =
      _$FeedErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FeedErrorCopyWithImpl<$Res> implements $FeedErrorCopyWith<$Res> {
  _$FeedErrorCopyWithImpl(this._self, this._then);

  final FeedError _self;
  final $Res Function(FeedError) _then;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(FeedError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
