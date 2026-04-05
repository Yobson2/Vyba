// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteModel {
  String get id;
  @JsonKey(name: 'server_id')
  String? get serverId;
  String get title;
  String get content;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSynced;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NoteModelCopyWith<NoteModel> get copyWith =>
      _$NoteModelCopyWithImpl<NoteModel>(this as NoteModel, _$identity);

  /// Serializes this NoteModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NoteModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, serverId, title, content,
      createdAt, updatedAt, isSynced);

  @override
  String toString() {
    return 'NoteModel(id: $id, serverId: $serverId, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class $NoteModelCopyWith<$Res> {
  factory $NoteModelCopyWith(NoteModel value, $Res Function(NoteModel) _then) =
      _$NoteModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'server_id') String? serverId,
      String title,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class _$NoteModelCopyWithImpl<$Res> implements $NoteModelCopyWith<$Res> {
  _$NoteModelCopyWithImpl(this._self, this._then);

  final NoteModel _self;
  final $Res Function(NoteModel) _then;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isSynced = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _self.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NoteModel extends NoteModel {
  const _NoteModel(
      {required this.id,
      @JsonKey(name: 'server_id') this.serverId,
      required this.title,
      required this.content,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isSynced = true})
      : super._();
  factory _NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'server_id')
  final String? serverId;
  @override
  final String title;
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSynced;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NoteModelCopyWith<_NoteModel> get copyWith =>
      __$NoteModelCopyWithImpl<_NoteModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NoteModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NoteModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, serverId, title, content,
      createdAt, updatedAt, isSynced);

  @override
  String toString() {
    return 'NoteModel(id: $id, serverId: $serverId, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced)';
  }
}

/// @nodoc
abstract mixin class _$NoteModelCopyWith<$Res>
    implements $NoteModelCopyWith<$Res> {
  factory _$NoteModelCopyWith(
          _NoteModel value, $Res Function(_NoteModel) _then) =
      __$NoteModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'server_id') String? serverId,
      String title,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSynced});
}

/// @nodoc
class __$NoteModelCopyWithImpl<$Res> implements _$NoteModelCopyWith<$Res> {
  __$NoteModelCopyWithImpl(this._self, this._then);

  final _NoteModel _self;
  final $Res Function(_NoteModel) _then;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? serverId = freezed,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isSynced = null,
  }) {
    return _then(_NoteModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _self.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _self.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
