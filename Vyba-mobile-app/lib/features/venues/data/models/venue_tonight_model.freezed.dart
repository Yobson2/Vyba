// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_tonight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VenueTonightModel {
  bool get isLive;
  DateTime? get liveSince;
  String? get headline;
  String? get djName;
  int get goingCount;

  /// Create a copy of VenueTonightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueTonightModelCopyWith<VenueTonightModel> get copyWith =>
      _$VenueTonightModelCopyWithImpl<VenueTonightModel>(
          this as VenueTonightModel, _$identity);

  /// Serializes this VenueTonightModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueTonightModel &&
            (identical(other.isLive, isLive) || other.isLive == isLive) &&
            (identical(other.liveSince, liveSince) ||
                other.liveSince == liveSince) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.djName, djName) || other.djName == djName) &&
            (identical(other.goingCount, goingCount) ||
                other.goingCount == goingCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isLive, liveSince, headline, djName, goingCount);

  @override
  String toString() {
    return 'VenueTonightModel(isLive: $isLive, liveSince: $liveSince, headline: $headline, djName: $djName, goingCount: $goingCount)';
  }
}

/// @nodoc
abstract mixin class $VenueTonightModelCopyWith<$Res> {
  factory $VenueTonightModelCopyWith(
          VenueTonightModel value, $Res Function(VenueTonightModel) _then) =
      _$VenueTonightModelCopyWithImpl;
  @useResult
  $Res call(
      {bool isLive,
      DateTime? liveSince,
      String? headline,
      String? djName,
      int goingCount});
}

/// @nodoc
class _$VenueTonightModelCopyWithImpl<$Res>
    implements $VenueTonightModelCopyWith<$Res> {
  _$VenueTonightModelCopyWithImpl(this._self, this._then);

  final VenueTonightModel _self;
  final $Res Function(VenueTonightModel) _then;

  /// Create a copy of VenueTonightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLive = null,
    Object? liveSince = freezed,
    Object? headline = freezed,
    Object? djName = freezed,
    Object? goingCount = null,
  }) {
    return _then(_self.copyWith(
      isLive: null == isLive
          ? _self.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
      liveSince: freezed == liveSince
          ? _self.liveSince
          : liveSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      headline: freezed == headline
          ? _self.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      djName: freezed == djName
          ? _self.djName
          : djName // ignore: cast_nullable_to_non_nullable
              as String?,
      goingCount: null == goingCount
          ? _self.goingCount
          : goingCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VenueTonightModel extends VenueTonightModel {
  const _VenueTonightModel(
      {required this.isLive,
      this.liveSince,
      this.headline,
      this.djName,
      this.goingCount = 0})
      : super._();
  factory _VenueTonightModel.fromJson(Map<String, dynamic> json) =>
      _$VenueTonightModelFromJson(json);

  @override
  final bool isLive;
  @override
  final DateTime? liveSince;
  @override
  final String? headline;
  @override
  final String? djName;
  @override
  @JsonKey()
  final int goingCount;

  /// Create a copy of VenueTonightModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VenueTonightModelCopyWith<_VenueTonightModel> get copyWith =>
      __$VenueTonightModelCopyWithImpl<_VenueTonightModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VenueTonightModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VenueTonightModel &&
            (identical(other.isLive, isLive) || other.isLive == isLive) &&
            (identical(other.liveSince, liveSince) ||
                other.liveSince == liveSince) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.djName, djName) || other.djName == djName) &&
            (identical(other.goingCount, goingCount) ||
                other.goingCount == goingCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isLive, liveSince, headline, djName, goingCount);

  @override
  String toString() {
    return 'VenueTonightModel(isLive: $isLive, liveSince: $liveSince, headline: $headline, djName: $djName, goingCount: $goingCount)';
  }
}

/// @nodoc
abstract mixin class _$VenueTonightModelCopyWith<$Res>
    implements $VenueTonightModelCopyWith<$Res> {
  factory _$VenueTonightModelCopyWith(
          _VenueTonightModel value, $Res Function(_VenueTonightModel) _then) =
      __$VenueTonightModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLive,
      DateTime? liveSince,
      String? headline,
      String? djName,
      int goingCount});
}

/// @nodoc
class __$VenueTonightModelCopyWithImpl<$Res>
    implements _$VenueTonightModelCopyWith<$Res> {
  __$VenueTonightModelCopyWithImpl(this._self, this._then);

  final _VenueTonightModel _self;
  final $Res Function(_VenueTonightModel) _then;

  /// Create a copy of VenueTonightModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLive = null,
    Object? liveSince = freezed,
    Object? headline = freezed,
    Object? djName = freezed,
    Object? goingCount = null,
  }) {
    return _then(_VenueTonightModel(
      isLive: null == isLive
          ? _self.isLive
          : isLive // ignore: cast_nullable_to_non_nullable
              as bool,
      liveSince: freezed == liveSince
          ? _self.liveSince
          : liveSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      headline: freezed == headline
          ? _self.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      djName: freezed == djName
          ? _self.djName
          : djName // ignore: cast_nullable_to_non_nullable
              as String?,
      goingCount: null == goingCount
          ? _self.goingCount
          : goingCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
