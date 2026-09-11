// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'going_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoingModel {
  String get id;
  String get venueId;
  int get partySize;
  bool get identityPublic;

  /// Create a copy of GoingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoingModelCopyWith<GoingModel> get copyWith =>
      _$GoingModelCopyWithImpl<GoingModel>(this as GoingModel, _$identity);

  /// Serializes this GoingModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoingModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.identityPublic, identityPublic) ||
                other.identityPublic == identityPublic));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, venueId, partySize, identityPublic);

  @override
  String toString() {
    return 'GoingModel(id: $id, venueId: $venueId, partySize: $partySize, identityPublic: $identityPublic)';
  }
}

/// @nodoc
abstract mixin class $GoingModelCopyWith<$Res> {
  factory $GoingModelCopyWith(
          GoingModel value, $Res Function(GoingModel) _then) =
      _$GoingModelCopyWithImpl;
  @useResult
  $Res call({String id, String venueId, int partySize, bool identityPublic});
}

/// @nodoc
class _$GoingModelCopyWithImpl<$Res> implements $GoingModelCopyWith<$Res> {
  _$GoingModelCopyWithImpl(this._self, this._then);

  final GoingModel _self;
  final $Res Function(GoingModel) _then;

  /// Create a copy of GoingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? partySize = null,
    Object? identityPublic = null,
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
      identityPublic: null == identityPublic
          ? _self.identityPublic
          : identityPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GoingModel extends GoingModel {
  const _GoingModel(
      {required this.id,
      required this.venueId,
      this.partySize = 1,
      this.identityPublic = false})
      : super._();
  factory _GoingModel.fromJson(Map<String, dynamic> json) =>
      _$GoingModelFromJson(json);

  @override
  final String id;
  @override
  final String venueId;
  @override
  @JsonKey()
  final int partySize;
  @override
  @JsonKey()
  final bool identityPublic;

  /// Create a copy of GoingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoingModelCopyWith<_GoingModel> get copyWith =>
      __$GoingModelCopyWithImpl<_GoingModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoingModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoingModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.identityPublic, identityPublic) ||
                other.identityPublic == identityPublic));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, venueId, partySize, identityPublic);

  @override
  String toString() {
    return 'GoingModel(id: $id, venueId: $venueId, partySize: $partySize, identityPublic: $identityPublic)';
  }
}

/// @nodoc
abstract mixin class _$GoingModelCopyWith<$Res>
    implements $GoingModelCopyWith<$Res> {
  factory _$GoingModelCopyWith(
          _GoingModel value, $Res Function(_GoingModel) _then) =
      __$GoingModelCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String venueId, int partySize, bool identityPublic});
}

/// @nodoc
class __$GoingModelCopyWithImpl<$Res> implements _$GoingModelCopyWith<$Res> {
  __$GoingModelCopyWithImpl(this._self, this._then);

  final _GoingModel _self;
  final $Res Function(_GoingModel) _then;

  /// Create a copy of GoingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? partySize = null,
    Object? identityPublic = null,
  }) {
    return _then(_GoingModel(
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
      identityPublic: null == identityPublic
          ? _self.identityPublic
          : identityPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
