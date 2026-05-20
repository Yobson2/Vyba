import 'package:flutter_templates/features/venues/domain/entities/venue_menu.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_menu_model.freezed.dart';
part 'venue_menu_model.g.dart';

@freezed
abstract class VenueMenuModel with _$VenueMenuModel {
  const VenueMenuModel._();

  const factory VenueMenuModel({
    required List<MenuCategoryModel> categories,
  }) = _VenueMenuModel;

  factory VenueMenuModel.fromJson(Map<String, dynamic> json) =>
      _$VenueMenuModelFromJson(json);

  VenueMenu toEntity() => VenueMenu(
        categories: categories.map((c) => c.toEntity()).toList(),
      );
}

@freezed
abstract class MenuCategoryModel with _$MenuCategoryModel {
  const MenuCategoryModel._();

  const factory MenuCategoryModel({
    required String name,
    required List<MenuItemModel> items,
  }) = _MenuCategoryModel;

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryModelFromJson(json);

  MenuCategory toEntity() => MenuCategory(
        name: name,
        items: items.map((i) => i.toEntity()).toList(),
      );
}

@freezed
abstract class MenuItemModel with _$MenuItemModel {
  const MenuItemModel._();

  const factory MenuItemModel({
    required String id,
    required String name,
    required double price,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _MenuItemModel;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  MenuItem toEntity() => MenuItem(
        id: id,
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl,
      );
}
