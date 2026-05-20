import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Search bar with clear button and debounced input.
class AppSearchField extends StatefulWidget {
  /// Creates an [AppSearchField].
  const AppSearchField({
    super.key,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.debounceDuration = const Duration(milliseconds: 400),
  });

  /// Hint text.
  final String hint;

  /// Debounced callback on text change.
  final ValueChanged<String>? onChanged;

  /// Callback when user submits.
  final ValueChanged<String>? onSubmitted;

  /// External controller.
  final TextEditingController? controller;

  /// Debounce duration for [onChanged].
  final Duration debounceDuration;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged?.call(value);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call('');
                  setState(() {});
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusFull,
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusFull,
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgx),
      ),
    );
  }
}
