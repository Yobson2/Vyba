import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_effects.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';

/// Pill-shaped status chip with glassmorphic background.
///
/// Used for venue availability status (Open Now, Closing Soon, Closed).
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    this.status = VenueStatus.open,
    this.icon,
  });

  final String label;
  final VenueStatus status;
  final IconData? icon;

  Color get _backgroundColor => switch (status) {
        VenueStatus.open => AppColors.secondaryContainer,
        VenueStatus.closingSoon =>
          AppColors.tertiaryContainer.withValues(alpha: AppOpacity.medium),
        VenueStatus.closed => AppColors.surfaceContainerHighest,
      };

  Color get _textColor => switch (status) {
        VenueStatus.open => AppColors.onSecondaryContainer,
        VenueStatus.closingSoon => AppColors.tertiaryFixed,
        VenueStatus.closed => AppColors.onSurfaceVariant,
      };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.borderRadiusFull,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.light, sigmaY: AppBlur.light),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: AppRadius.borderRadiusFull,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: _textColor, size: AppIconSize.xs),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _textColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum VenueStatus { open, closingSoon, closed }
