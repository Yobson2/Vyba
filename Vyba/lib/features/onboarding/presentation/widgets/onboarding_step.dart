import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Single onboarding step with icon, title, and description.
class OnboardingStep extends StatelessWidget {
  /// Creates an [OnboardingStep].
  const OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  /// Large icon displayed in the center.
  final IconData icon;

  /// Step title.
  final String title;

  /// Step description.
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: AppSpacing.paddingHorizontalXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            icon,
            size: 120,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.verticalXxxl,
          Text(
            title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalLg,
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
