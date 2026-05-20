import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Styled text field with label, hint, error, prefix/suffix support.
///
/// Wraps [TextFormField] with consistent theming from [AppTheme].
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.focusNode,
    this.autofillHints,
  });

  /// Text editing controller.
  final TextEditingController? controller;

  /// Label text shown above the field.
  final String? label;

  /// Hint text inside the field.
  final String? hint;

  /// Error text shown below the field.
  final String? errorText;

  /// Leading icon.
  final Widget? prefixIcon;

  /// Trailing icon/widget.
  final Widget? suffixIcon;

  /// Whether text is obscured (passwords).
  final bool obscureText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Maximum number of lines.
  final int maxLines;

  /// Maximum character length.
  final int? maxLength;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Action button on keyboard.
  final TextInputAction? textInputAction;

  /// Form validation callback.
  final String? Function(String?)? validator;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when user submits.
  final ValueChanged<String>? onSubmitted;

  /// Input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Focus node.
  final FocusNode? focusNode;

  /// Autofill hints.
  final Iterable<String>? autofillHints;

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
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
