// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvailabilityModel {
  bool get reservationsEnabled;
  int? get confirmedReservationsCount;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AvailabilityModelCopyWith<AvailabilityModel> get copyWith =>
      _$AvailabilityModelCopyWithImpl<AvailabilityModel>(
          this as AvailabilityModel, _$identity);

  /// Serializes this AvailabilityModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvailabilityModel &&
            (identical(other.reservationsEnabled, reservationsEnabled) ||
                other.reservationsEnabled == reservationsEnabled) &&
            (identical(other.confirmedReservationsCount,
                    confirmedReservationsCount) ||
                other.confirmedReservationsCount ==
                    confirmedReservationsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, reservationsEnabled, confirmedReservationsCount);

  @override
  String toString() {
    return 'AvailabilityModel(reservationsEnabled: $reservationsEnabled, confirmedReservationsCount: $confirmedReservationsCount)';
  }
}

/// @nodoc
abstract mixin class $AvailabilityModelCopyWith<$Res> {
  factory $AvailabilityModelCopyWith(
          AvailabilityModel value, $Res Function(AvailabilityModel) _then) =
      _$AvailabilityModelCopyWithImpl;
  @useResult
  $Res call({bool reservationsEnabled, int? confirmedReservationsCount});
}

/// @nodoc
class _$AvailabilityModelCopyWithImpl<$Res>
    implements $AvailabilityModelCopyWith<$Res> {
  _$AvailabilityModelCopyWithImpl(this._self, this._then);

  final AvailabilityModel _self;
  final $Res Function(AvailabilityModel) _then;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationsEnabled = null,
    Object? confirmedReservationsCount = freezed,
  }) {
    return _then(_self.copyWith(
      reservationsEnabled: null == reservationsEnabled
          ? _self.reservationsEnabled
          : reservationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      confirmedReservationsCount: freezed == confirmedReservationsCount
          ? _self.confirmedReservationsCount
          : confirmedReservationsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AvailabilityModel extends AvailabilityModel {
  const _AvailabilityModel(
      {this.reservationsEnabled = false, this.confirmedReservationsCount})
      : super._();
  factory _AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);

  @override
  @JsonKey()
  final bool reservationsEnabled;
  @override
  final int? confirmedReservationsCount;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AvailabilityModelCopyWith<_AvailabilityModel> get copyWith =>
      __$AvailabilityModelCopyWithImpl<_AvailabilityModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AvailabilityModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AvailabilityModel &&
            (identical(other.reservationsEnabled, reservationsEnabled) ||
                other.reservationsEnabled == reservationsEnabled) &&
            (identical(other.confirmedReservationsCount,
                    confirmedReservationsCount) ||
                other.confirmedReservationsCount ==
                    confirmedReservationsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, reservationsEnabled, confirmedReservationsCount);

  @override
  String toString() {
    return 'AvailabilityModel(reservationsEnabled: $reservationsEnabled, confirmedReservationsCount: $confirmedReservationsCount)';
  }
}

/// @nodoc
abstract mixin class _$AvailabilityModelCopyWith<$Res>
    implements $AvailabilityModelCopyWith<$Res> {
  factory _$AvailabilityModelCopyWith(
          _AvailabilityModel value, $Res Function(_AvailabilityModel) _then) =
      __$AvailabilityModelCopyWithImpl;
  @override
  @useResult
  $Res call({bool reservationsEnabled, int? confirmedReservationsCount});
}

/// @nodoc
class __$AvailabilityModelCopyWithImpl<$Res>
    implements _$AvailabilityModelCopyWith<$Res> {
  __$AvailabilityModelCopyWithImpl(this._self, this._then);

  final _AvailabilityModel _self;
  final $Res Function(_AvailabilityModel) _then;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reservationsEnabled = null,
    Object? confirmedReservationsCount = freezed,
  }) {
    return _then(_AvailabilityModel(
      reservationsEnabled: null == reservationsEnabled
          ? _self.reservationsEnabled
          : reservationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      confirmedReservationsCount: freezed == confirmedReservationsCount
          ? _self.confirmedReservationsCount
          : confirmedReservationsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
