import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Multi-box OTP/PIN input field.
class AppOtpField extends StatefulWidget {
  /// Creates an [AppOtpField].
  const AppOtpField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
  });

  /// Number of OTP digits.
  final int length;

  /// Called when all digits are filled.
  final ValueChanged<String>? onCompleted;

  /// Called on each digit change.
  final ValueChanged<String>? onChanged;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<FocusNode> _keyboardListenerNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _keyboardListenerNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    for (final f in _keyboardListenerNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onChanged(String value, int index) {
    // Handle paste: if user pastes a multi-digit string, distribute digits.
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < digits.length && (index + i) < widget.length; i++) {
        _controllers[index + i].text = digits[i];
      }
      final nextIndex = (index + digits.length).clamp(0, widget.length - 1);
      _focusNodes[nextIndex].requestFocus();
    } else if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    widget.onChanged?.call(_otp);

    if (_otp.length == widget.length) {
      widget.onCompleted?.call(_otp);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 48,
          height: 56,
          margin: EdgeInsets.only(
            right: index < widget.length - 1 ? AppSpacing.sm : 0,
          ),
          child: KeyboardListener(
            focusNode: _keyboardListenerNodes[index],
            onKeyEvent: (event) => _onKeyEvent(index, event),
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: theme.textTheme.headlineSmall,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
              ),
              onChanged: (value) => _onChanged(value, index),
            ),
          ),
        );
      }),
    );
  }
}
