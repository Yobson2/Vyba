import 'package:flutter/material.dart';

/// Icon-only circular button.
class AppIconButton extends StatelessWidget {
  /// Creates an [AppIconButton].
  const AppIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size = 48,
    this.iconSize = 24,
    this.color,
    this.backgroundColor,
    this.tooltip,
  });

  /// Icon to display.
  final IconData icon;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Overall button size.
  final double size;

  /// Size of the icon.
  final double iconSize;

  /// Icon color. Defaults to [ColorScheme.onSurface].
  final Color? color;

  /// Background fill color. Defaults to transparent.
  final Color? backgroundColor;

  /// Optional tooltip text.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: tooltip,
      child: SizedBox(
        width: size,
        height: size,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize),
          color: color ?? theme.colorScheme.onSurface,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: const CircleBorder(),
          ),
          tooltip: tooltip,
        ),
      ),
    );
  }
}
