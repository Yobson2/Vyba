import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Themed dropdown field with label support.
class AppDropdown<T> extends StatelessWidget {
  /// Creates an [AppDropdown].
  const AppDropdown({
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.label,
    this.hint,
    this.validator,
    this.isExpanded = true,
  });

  /// Currently selected value.
  final T? value;

  /// Dropdown items.
  final List<DropdownMenuItem<T>> items;

  /// Callback when selection changes.
  final ValueChanged<T?>? onChanged;

  /// Label above the dropdown.
  final String? label;

  /// Placeholder hint text.
  final String? hint;

  /// Form validator.
  final String? Function(T?)? validator;

  /// Whether the dropdown takes full width.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelLarge),
          AppSpacing.verticalSm,
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          isExpanded: isExpanded,
          hint: hint != null ? Text(hint!) : null,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
