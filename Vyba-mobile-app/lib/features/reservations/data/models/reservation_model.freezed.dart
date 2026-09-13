// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReservationModel {
  String get id;
  String get venueId;
  int get partySize;
  String? get note;
  String get status;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationModelCopyWith<ReservationModel> get copyWith =>
      _$ReservationModelCopyWithImpl<ReservationModel>(
          this as ReservationModel, _$identity);

  /// Serializes this ReservationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, venueId, partySize, note, status);

  @override
  String toString() {
    return 'ReservationModel(id: $id, venueId: $venueId, partySize: $partySize, note: $note, status: $status)';
  }
}

/// @nodoc
abstract mixin class $ReservationModelCopyWith<$Res> {
  factory $ReservationModelCopyWith(
          ReservationModel value, $Res Function(ReservationModel) _then) =
      _$ReservationModelCopyWithImpl;
  @useResult
  $Res call(
      {String id, String venueId, int partySize, String? note, String status});
}

/// @nodoc
class _$ReservationModelCopyWithImpl<$Res>
    implements $ReservationModelCopyWith<$Res> {
  _$ReservationModelCopyWithImpl(this._self, this._then);

  final ReservationModel _self;
  final $Res Function(ReservationModel) _then;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? partySize = null,
    Object? note = freezed,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _self.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      partySize: null == partySize
          ? _self.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ReservationModel extends ReservationModel {
  const _ReservationModel(
      {required this.id,
      required this.venueId,
      this.partySize = 1,
      this.note,
      this.status = 'PENDING'})
      : super._();
  factory _ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);

  @override
  final String id;
  @override
  final String venueId;
  @override
  @JsonKey()
  final int partySize;
  @override
  final String? note;
  @override
  @JsonKey()
  final String status;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReservationModelCopyWith<_ReservationModel> get copyWith =>
      __$ReservationModelCopyWithImpl<_ReservationModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReservationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReservationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, venueId, partySize, note, status);

  @override
  String toString() {
    return 'ReservationModel(id: $id, venueId: $venueId, partySize: $partySize, note: $note, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$ReservationModelCopyWith<$Res>
    implements $ReservationModelCopyWith<$Res> {
  factory _$ReservationModelCopyWith(
          _ReservationModel value, $Res Function(_ReservationModel) _then) =
      __$ReservationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String venueId, int partySize, String? note, String status});
}

/// @nodoc
class __$ReservationModelCopyWithImpl<$Res>
    implements _$ReservationModelCopyWith<$Res> {
  __$ReservationModelCopyWithImpl(this._self, this._then);

  final _ReservationModel _self;
  final $Res Function(_ReservationModel) _then;

  /// Create a copy of ReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? partySize = null,
    Object? note = freezed,
    Object? status = null,
  }) {
    return _then(_ReservationModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _self.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      partySize: null == partySize
          ? _self.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
