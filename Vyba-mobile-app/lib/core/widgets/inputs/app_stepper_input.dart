import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';

/// +/- guest count stepper control.
class AppStepperInput extends StatelessWidget {
  const AppStepperInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 20,
    this.label,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: AppRadius.borderRadiusMd,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepperButton(
                icon: Icons.remove,
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              SizedBox(
                width: 48,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
              ),
              _StepperButton(
                icon: Icons.add,
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: onPressed != null
                ? AppColors.primary
                : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
            size: 20,
          ),
        ),
      ),
    );
  }
}
