// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VenueMenuModel _$VenueMenuModelFromJson(Map<String, dynamic> json) =>
    _VenueMenuModel(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => MenuCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VenueMenuModelToJson(_VenueMenuModel instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };

_MenuCategoryModel _$MenuCategoryModelFromJson(Map<String, dynamic> json) =>
    _MenuCategoryModel(
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuCategoryModelToJson(_MenuCategoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'items': instance.items,
    };

_MenuItemModel _$MenuItemModelFromJson(Map<String, dynamic> json) =>
    _MenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$MenuItemModelToJson(_MenuItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'image_url': instance.imageUrl,
    };
