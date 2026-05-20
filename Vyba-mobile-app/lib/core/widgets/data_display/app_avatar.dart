import 'package:flutter/material.dart';
import 'package:flutter_templates/core/extensions/string_extensions.dart';

/// Circle avatar with image, initials, or placeholder icon.
class AppAvatar extends StatelessWidget {
  /// Creates an [AppAvatar].
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 24,
    this.backgroundColor,
  });

  /// Network image URL. Takes priority over [name].
  final String? imageUrl;

  /// Name for generating initials fallback.
  final String? name;

  /// Radius of the circle.
  final double radius;

  /// Background color. Defaults to primary container.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primaryContainer;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: bgColor,
        onBackgroundImageError: (_, __) {},
      );
    }

    if (name != null && name!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Text(
          name!.initials,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: radius * 0.7,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Icon(
        Icons.person,
        size: radius,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
