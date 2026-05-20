import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Row of social login buttons (Google & Apple).
class SocialLoginButtons extends StatelessWidget {
  /// Creates [SocialLoginButtons].
  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.googleLabel = 'Continue with Google',
    this.appleLabel = 'Continue with Apple',
  });

  /// Callback for Google sign-in.
  final VoidCallback? onGooglePressed;

  /// Callback for Apple sign-in.
  final VoidCallback? onApplePressed;

  /// Google button label. Override for i18n.
  final String googleLabel;

  /// Apple button label. Override for i18n.
  final String appleLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _SocialButton(
          onPressed: onGooglePressed,
          icon: Icons.g_mobiledata,
          label: googleLabel,
          theme: theme,
        ),
        AppSpacing.verticalMd,
        _SocialButton(
          onPressed: onApplePressed,
          icon: Icons.apple,
          label: appleLabel,
          theme: theme,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.theme,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(color: theme.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
      ),
    );
  }
}
