// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncStatus {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SyncStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SyncStatus()';
  }
}

/// @nodoc
class $SyncStatusCopyWith<$Res> {
  $SyncStatusCopyWith(SyncStatus _, $Res Function(SyncStatus) __);
}

/// @nodoc

class SyncIdle implements SyncStatus {
  const SyncIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SyncIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SyncStatus.idle()';
  }
}

/// @nodoc

class SyncSyncing implements SyncStatus {
  const SyncSyncing({required this.total, required this.completed});

  final int total;
  final int completed;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncSyncingCopyWith<SyncSyncing> get copyWith =>
      _$SyncSyncingCopyWithImpl<SyncSyncing>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncSyncing &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, total, completed);

  @override
  String toString() {
    return 'SyncStatus.syncing(total: $total, completed: $completed)';
  }
}

/// @nodoc
abstract mixin class $SyncSyncingCopyWith<$Res>
    implements $SyncStatusCopyWith<$Res> {
  factory $SyncSyncingCopyWith(
          SyncSyncing value, $Res Function(SyncSyncing) _then) =
      _$SyncSyncingCopyWithImpl;
  @useResult
  $Res call({int total, int completed});
}

/// @nodoc
class _$SyncSyncingCopyWithImpl<$Res> implements $SyncSyncingCopyWith<$Res> {
  _$SyncSyncingCopyWithImpl(this._self, this._then);

  final SyncSyncing _self;
  final $Res Function(SyncSyncing) _then;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? total = null,
    Object? completed = null,
  }) {
    return _then(SyncSyncing(
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class SyncSynced implements SyncStatus {
  const SyncSynced();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SyncSynced);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SyncStatus.synced()';
  }
}

/// @nodoc

class SyncError implements SyncStatus {
  const SyncError(this.message);

  final String message;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncErrorCopyWith<SyncError> get copyWith =>
      _$SyncErrorCopyWithImpl<SyncError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'SyncStatus.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $SyncErrorCopyWith<$Res>
    implements $SyncStatusCopyWith<$Res> {
  factory $SyncErrorCopyWith(SyncError value, $Res Function(SyncError) _then) =
      _$SyncErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$SyncErrorCopyWithImpl<$Res> implements $SyncErrorCopyWith<$Res> {
  _$SyncErrorCopyWithImpl(this._self, this._then);

  final SyncError _self;
  final $Res Function(SyncError) _then;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(SyncError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class SyncOffline implements SyncStatus {
  const SyncOffline({required this.pendingCount});

  final int pendingCount;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncOfflineCopyWith<SyncOffline> get copyWith =>
      _$SyncOfflineCopyWithImpl<SyncOffline>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncOffline &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pendingCount);

  @override
  String toString() {
    return 'SyncStatus.offline(pendingCount: $pendingCount)';
  }
}

/// @nodoc
abstract mixin class $SyncOfflineCopyWith<$Res>
    implements $SyncStatusCopyWith<$Res> {
  factory $SyncOfflineCopyWith(
          SyncOffline value, $Res Function(SyncOffline) _then) =
      _$SyncOfflineCopyWithImpl;
  @useResult
  $Res call({int pendingCount});
}

/// @nodoc
class _$SyncOfflineCopyWithImpl<$Res> implements $SyncOfflineCopyWith<$Res> {
  _$SyncOfflineCopyWithImpl(this._self, this._then);

  final SyncOffline _self;
  final $Res Function(SyncOffline) _then;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pendingCount = null,
  }) {
    return _then(SyncOffline(
      pendingCount: null == pendingCount
          ? _self.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
