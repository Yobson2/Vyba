import 'package:flutter/material.dart';

/// Themed app bar with optional back button and actions.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an [AppAppBar].
  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
  });

  /// Title text.
  final String? title;

  /// Custom title widget (overrides [title]).
  final Widget? titleWidget;

  /// Trailing action widgets.
  final List<Widget>? actions;

  /// Leading widget (overrides back button).
  final Widget? leading;

  /// Whether to show the back button.
  final bool showBackButton;

  /// Whether to center the title.
  final bool centerTitle;

  /// Elevation.
  final double elevation;

  /// Background color override.
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: showBackButton,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor,
    );
  }
}
