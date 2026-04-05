// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_menu_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VenueMenuModel {
  List<MenuCategoryModel> get categories;

  /// Create a copy of VenueMenuModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueMenuModelCopyWith<VenueMenuModel> get copyWith =>
      _$VenueMenuModelCopyWithImpl<VenueMenuModel>(
          this as VenueMenuModel, _$identity);

  /// Serializes this VenueMenuModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueMenuModel &&
            const DeepCollectionEquality()
                .equals(other.categories, categories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(categories));

  @override
  String toString() {
    return 'VenueMenuModel(categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $VenueMenuModelCopyWith<$Res> {
  factory $VenueMenuModelCopyWith(
          VenueMenuModel value, $Res Function(VenueMenuModel) _then) =
      _$VenueMenuModelCopyWithImpl;
  @useResult
  $Res call({List<MenuCategoryModel> categories});
}

/// @nodoc
class _$VenueMenuModelCopyWithImpl<$Res>
    implements $VenueMenuModelCopyWith<$Res> {
  _$VenueMenuModelCopyWithImpl(this._self, this._then);

  final VenueMenuModel _self;
  final $Res Function(VenueMenuModel) _then;

  /// Create a copy of VenueMenuModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
  }) {
    return _then(_self.copyWith(
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<MenuCategoryModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VenueMenuModel extends VenueMenuModel {
  const _VenueMenuModel({required final List<MenuCategoryModel> categories})
      : _categories = categories,
        super._();
  factory _VenueMenuModel.fromJson(Map<String, dynamic> json) =>
      _$VenueMenuModelFromJson(json);

  final List<MenuCategoryModel> _categories;
  @override
  List<MenuCategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of VenueMenuModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VenueMenuModelCopyWith<_VenueMenuModel> get copyWith =>
      __$VenueMenuModelCopyWithImpl<_VenueMenuModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VenueMenuModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VenueMenuModel &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'VenueMenuModel(categories: $categories)';
  }
}

/// @nodoc
abstract mixin class _$VenueMenuModelCopyWith<$Res>
    implements $VenueMenuModelCopyWith<$Res> {
  factory _$VenueMenuModelCopyWith(
          _VenueMenuModel value, $Res Function(_VenueMenuModel) _then) =
      __$VenueMenuModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<MenuCategoryModel> categories});
}

/// @nodoc
class __$VenueMenuModelCopyWithImpl<$Res>
    implements _$VenueMenuModelCopyWith<$Res> {
  __$VenueMenuModelCopyWithImpl(this._self, this._then);

  final _VenueMenuModel _self;
  final $Res Function(_VenueMenuModel) _then;

  /// Create a copy of VenueMenuModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
  }) {
    return _then(_VenueMenuModel(
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<MenuCategoryModel>,
    ));
  }
}

/// @nodoc
mixin _$MenuCategoryModel {
  String get name;
  List<MenuItemModel> get items;

  /// Create a copy of MenuCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MenuCategoryModelCopyWith<MenuCategoryModel> get copyWith =>
      _$MenuCategoryModelCopyWithImpl<MenuCategoryModel>(
          this as MenuCategoryModel, _$identity);

  /// Serializes this MenuCategoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MenuCategoryModel &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(items));

  @override
  String toString() {
    return 'MenuCategoryModel(name: $name, items: $items)';
  }
}

/// @nodoc
abstract mixin class $MenuCategoryModelCopyWith<$Res> {
  factory $MenuCategoryModelCopyWith(
          MenuCategoryModel value, $Res Function(MenuCategoryModel) _then) =
      _$MenuCategoryModelCopyWithImpl;
  @useResult
  $Res call({String name, List<MenuItemModel> items});
}

/// @nodoc
class _$MenuCategoryModelCopyWithImpl<$Res>
    implements $MenuCategoryModelCopyWith<$Res> {
  _$MenuCategoryModelCopyWithImpl(this._self, this._then);

  final MenuCategoryModel _self;
  final $Res Function(MenuCategoryModel) _then;

  /// Create a copy of MenuCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? items = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<MenuItemModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MenuCategoryModel extends MenuCategoryModel {
  const _MenuCategoryModel(
      {required this.name, required final List<MenuItemModel> items})
      : _items = items,
        super._();
  factory _MenuCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryModelFromJson(json);

  @override
  final String name;
  final List<MenuItemModel> _items;
  @override
  List<MenuItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of MenuCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MenuCategoryModelCopyWith<_MenuCategoryModel> get copyWith =>
      __$MenuCategoryModelCopyWithImpl<_MenuCategoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MenuCategoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MenuCategoryModel &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'MenuCategoryModel(name: $name, items: $items)';
  }
}

/// @nodoc
abstract mixin class _$MenuCategoryModelCopyWith<$Res>
    implements $MenuCategoryModelCopyWith<$Res> {
  factory _$MenuCategoryModelCopyWith(
          _MenuCategoryModel value, $Res Function(_MenuCategoryModel) _then) =
      __$MenuCategoryModelCopyWithImpl;
  @override
  @useResult
  $Res call({String name, List<MenuItemModel> items});
}

/// @nodoc
class __$MenuCategoryModelCopyWithImpl<$Res>
    implements _$MenuCategoryModelCopyWith<$Res> {
  __$MenuCategoryModelCopyWithImpl(this._self, this._then);

  final _MenuCategoryModel _self;
  final $Res Function(_MenuCategoryModel) _then;

  /// Create a copy of MenuCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? items = null,
  }) {
    return _then(_MenuCategoryModel(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<MenuItemModel>,
    ));
  }
}

/// @nodoc
mixin _$MenuItemModel {
  String get id;
  String get name;
  double get price;
  String? get description;
  @JsonKey(name: 'image_url')
  String? get imageUrl;

  /// Create a copy of MenuItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MenuItemModelCopyWith<MenuItemModel> get copyWith =>
      _$MenuItemModelCopyWithImpl<MenuItemModel>(
          this as MenuItemModel, _$identity);

  /// Serializes this MenuItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MenuItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, price, description, imageUrl);

  @override
  String toString() {
    return 'MenuItemModel(id: $id, name: $name, price: $price, description: $description, imageUrl: $imageUrl)';
  }
}

/// @nodoc
abstract mixin class $MenuItemModelCopyWith<$Res> {
  factory $MenuItemModelCopyWith(
          MenuItemModel value, $Res Function(MenuItemModel) _then) =
      _$MenuItemModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      double price,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl});
}

/// @nodoc
class _$MenuItemModelCopyWithImpl<$Res>
    implements $MenuItemModelCopyWith<$Res> {
  _$MenuItemModelCopyWithImpl(this._self, this._then);

  final MenuItemModel _self;
  final $Res Function(MenuItemModel) _then;

  /// Create a copy of MenuItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MenuItemModel extends MenuItemModel {
  const _MenuItemModel(
      {required this.id,
      required this.name,
      required this.price,
      this.description,
      @JsonKey(name: 'image_url') this.imageUrl})
      : super._();
  factory _MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  /// Create a copy of MenuItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MenuItemModelCopyWith<_MenuItemModel> get copyWith =>
      __$MenuItemModelCopyWithImpl<_MenuItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MenuItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MenuItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, price, description, imageUrl);

  @override
  String toString() {
    return 'MenuItemModel(id: $id, name: $name, price: $price, description: $description, imageUrl: $imageUrl)';
  }
}

/// @nodoc
abstract mixin class _$MenuItemModelCopyWith<$Res>
    implements $MenuItemModelCopyWith<$Res> {
  factory _$MenuItemModelCopyWith(
          _MenuItemModel value, $Res Function(_MenuItemModel) _then) =
      __$MenuItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double price,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl});
}

/// @nodoc
class __$MenuItemModelCopyWithImpl<$Res>
    implements _$MenuItemModelCopyWith<$Res> {
  __$MenuItemModelCopyWithImpl(this._self, this._then);

  final _MenuItemModel _self;
  final $Res Function(_MenuItemModel) _then;

  /// Create a copy of MenuItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_MenuItemModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
