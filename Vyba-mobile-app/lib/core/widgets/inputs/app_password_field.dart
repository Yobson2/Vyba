import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Password field with a visibility toggle button.
class AppPasswordField extends StatefulWidget {
  /// Creates an [AppPasswordField].
  const AppPasswordField({
    super.key,
    this.controller,
    this.label,
    this.hint = 'Enter your password',
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
    this.errorText,
  });

  /// Text editing controller.
  final TextEditingController? controller;

  /// Label above the field.
  final String? label;

  /// Hint text.
  final String? hint;

  /// Form validator.
  final String? Function(String?)? validator;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Keyboard action button.
  final TextInputAction? textInputAction;

  /// Called when user submits.
  final ValueChanged<String>? onSubmitted;

  /// Error text shown below the field.
  final String? errorText;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: Theme.of(context).textTheme.labelLarge),
          AppSpacing.verticalSm,
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          validator: widget.validator,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
      ],
    );
  }
}
