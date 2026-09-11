// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_promo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VenuePromoModel {
  String get id;
  String get title;
  String get description;
  DateTime get publishedAt;

  /// Create a copy of VenuePromoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenuePromoModelCopyWith<VenuePromoModel> get copyWith =>
      _$VenuePromoModelCopyWithImpl<VenuePromoModel>(
          this as VenuePromoModel, _$identity);

  /// Serializes this VenuePromoModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenuePromoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, description, publishedAt);

  @override
  String toString() {
    return 'VenuePromoModel(id: $id, title: $title, description: $description, publishedAt: $publishedAt)';
  }
}

/// @nodoc
abstract mixin class $VenuePromoModelCopyWith<$Res> {
  factory $VenuePromoModelCopyWith(
          VenuePromoModel value, $Res Function(VenuePromoModel) _then) =
      _$VenuePromoModelCopyWithImpl;
  @useResult
  $Res call(
      {String id, String title, String description, DateTime publishedAt});
}

/// @nodoc
class _$VenuePromoModelCopyWithImpl<$Res>
    implements $VenuePromoModelCopyWith<$Res> {
  _$VenuePromoModelCopyWithImpl(this._self, this._then);

  final VenuePromoModel _self;
  final $Res Function(VenuePromoModel) _then;

  /// Create a copy of VenuePromoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? publishedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VenuePromoModel extends VenuePromoModel {
  const _VenuePromoModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.publishedAt})
      : super._();
  factory _VenuePromoModel.fromJson(Map<String, dynamic> json) =>
      _$VenuePromoModelFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime publishedAt;

  /// Create a copy of VenuePromoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VenuePromoModelCopyWith<_VenuePromoModel> get copyWith =>
      __$VenuePromoModelCopyWithImpl<_VenuePromoModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VenuePromoModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VenuePromoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, description, publishedAt);

  @override
  String toString() {
    return 'VenuePromoModel(id: $id, title: $title, description: $description, publishedAt: $publishedAt)';
  }
}

/// @nodoc
abstract mixin class _$VenuePromoModelCopyWith<$Res>
    implements $VenuePromoModelCopyWith<$Res> {
  factory _$VenuePromoModelCopyWith(
          _VenuePromoModel value, $Res Function(_VenuePromoModel) _then) =
      __$VenuePromoModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String title, String description, DateTime publishedAt});
}

/// @nodoc
class __$VenuePromoModelCopyWithImpl<$Res>
    implements _$VenuePromoModelCopyWith<$Res> {
  __$VenuePromoModelCopyWithImpl(this._self, this._then);

  final _VenuePromoModel _self;
  final $Res Function(_VenuePromoModel) _then;

  /// Create a copy of VenuePromoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? publishedAt = null,
  }) {
    return _then(_VenuePromoModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
