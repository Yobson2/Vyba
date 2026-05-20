import 'package:flutter/foundation.dart';

/// A venue's menu with categorized items.
@immutable
class VenueMenu {
  const VenueMenu({
    required this.categories,
  });

  final List<MenuCategory> categories;
}

@immutable
class MenuCategory {
  const MenuCategory({
    required this.name,
    required this.items,
  });

  final String name;
  final List<MenuItem> items;
}

@immutable
class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
  });

  final String id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;

  String get formattedPrice => '₦${price.toStringAsFixed(0)}';
}
