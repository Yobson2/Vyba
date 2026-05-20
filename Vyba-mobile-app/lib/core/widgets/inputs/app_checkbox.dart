import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Themed labeled checkbox.
class AppCheckbox extends StatelessWidget {
  /// Creates an [AppCheckbox].
  const AppCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.labelWidget,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the checkbox value changes.
  final ValueChanged<bool?> onChanged;

  /// Simple text label.
  final String? label;

  /// Custom label widget (overrides [label]).
  final Widget? labelWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
            ),
            AppSpacing.horizontalSm,
            if (labelWidget != null)
              Flexible(child: labelWidget!)
            else if (label != null)
              Flexible(
                child: Text(
                  label!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
