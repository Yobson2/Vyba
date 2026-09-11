// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_going_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerGoingSummaryModel {
  int get count;
  List<int> get partySizes;

  /// Create a copy of OwnerGoingSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OwnerGoingSummaryModelCopyWith<OwnerGoingSummaryModel> get copyWith =>
      _$OwnerGoingSummaryModelCopyWithImpl<OwnerGoingSummaryModel>(
          this as OwnerGoingSummaryModel, _$identity);

  /// Serializes this OwnerGoingSummaryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OwnerGoingSummaryModel &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality()
                .equals(other.partySizes, partySizes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, count, const DeepCollectionEquality().hash(partySizes));

  @override
  String toString() {
    return 'OwnerGoingSummaryModel(count: $count, partySizes: $partySizes)';
  }
}

/// @nodoc
abstract mixin class $OwnerGoingSummaryModelCopyWith<$Res> {
  factory $OwnerGoingSummaryModelCopyWith(OwnerGoingSummaryModel value,
          $Res Function(OwnerGoingSummaryModel) _then) =
      _$OwnerGoingSummaryModelCopyWithImpl;
  @useResult
  $Res call({int count, List<int> partySizes});
}

/// @nodoc
class _$OwnerGoingSummaryModelCopyWithImpl<$Res>
    implements $OwnerGoingSummaryModelCopyWith<$Res> {
  _$OwnerGoingSummaryModelCopyWithImpl(this._self, this._then);

  final OwnerGoingSummaryModel _self;
  final $Res Function(OwnerGoingSummaryModel) _then;

  /// Create a copy of OwnerGoingSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? partySizes = null,
  }) {
    return _then(_self.copyWith(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      partySizes: null == partySizes
          ? _self.partySizes
          : partySizes // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OwnerGoingSummaryModel extends OwnerGoingSummaryModel {
  const _OwnerGoingSummaryModel(
      {this.count = 0, final List<int> partySizes = const []})
      : _partySizes = partySizes,
        super._();
  factory _OwnerGoingSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerGoingSummaryModelFromJson(json);

  @override
  @JsonKey()
  final int count;
  final List<int> _partySizes;
  @override
  @JsonKey()
  List<int> get partySizes {
    if (_partySizes is EqualUnmodifiableListView) return _partySizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_partySizes);
  }

  /// Create a copy of OwnerGoingSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OwnerGoingSummaryModelCopyWith<_OwnerGoingSummaryModel> get copyWith =>
      __$OwnerGoingSummaryModelCopyWithImpl<_OwnerGoingSummaryModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OwnerGoingSummaryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OwnerGoingSummaryModel &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality()
                .equals(other._partySizes, _partySizes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, count, const DeepCollectionEquality().hash(_partySizes));

  @override
  String toString() {
    return 'OwnerGoingSummaryModel(count: $count, partySizes: $partySizes)';
  }
}

/// @nodoc
abstract mixin class _$OwnerGoingSummaryModelCopyWith<$Res>
    implements $OwnerGoingSummaryModelCopyWith<$Res> {
  factory _$OwnerGoingSummaryModelCopyWith(_OwnerGoingSummaryModel value,
          $Res Function(_OwnerGoingSummaryModel) _then) =
      __$OwnerGoingSummaryModelCopyWithImpl;
  @override
  @useResult
  $Res call({int count, List<int> partySizes});
}

/// @nodoc
class __$OwnerGoingSummaryModelCopyWithImpl<$Res>
    implements _$OwnerGoingSummaryModelCopyWith<$Res> {
  __$OwnerGoingSummaryModelCopyWithImpl(this._self, this._then);

  final _OwnerGoingSummaryModel _self;
  final $Res Function(_OwnerGoingSummaryModel) _then;

  /// Create a copy of OwnerGoingSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
    Object? partySizes = null,
  }) {
    return _then(_OwnerGoingSummaryModel(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      partySizes: null == partySizes
          ? _self._partySizes
          : partySizes // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

// dart format on
