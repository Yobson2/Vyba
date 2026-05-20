import 'package:flutter/material.dart';

/// Themed chip for filtering or selection.
class AppChip extends StatelessWidget {
  /// Creates an [AppChip].
  const AppChip({
    required this.label,
    super.key,
    this.isSelected = false,
    this.onTap,
    this.avatar,
    this.onDeleted,
  });

  /// Chip label text.
  final String label;

  /// Whether the chip is selected.
  final bool isSelected;

  /// Called when the chip is tapped.
  final VoidCallback? onTap;

  /// Optional leading avatar/icon.
  final Widget? avatar;

  /// Called when the delete icon is tapped. Shows an X button.
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (onDeleted != null) {
      return InputChip(
        label: Text(label),
        avatar: avatar,
        onDeleted: onDeleted,
        selected: isSelected,
        onPressed: onTap,
      );
    }

    return FilterChip(
      label: Text(label),
      avatar: avatar,
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
    );
  }
}
