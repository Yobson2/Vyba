import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_effects.dart';
import 'package:flutter_templates/core/theme/app_motion.dart';
import 'package:flutter_templates/core/theme/app_shadows.dart';

/// Themed bottom navigation bar item data.
class AppBottomNavItem {
  /// Creates an [AppBottomNavItem].
  const AppBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  /// Default icon.
  final IconData icon;

  /// Icon when selected.
  final IconData activeIcon;

  /// Label text.
  final String label;
}

/// Glassmorphic bottom navigation bar with active glow indicator.
class AppBottomNav extends StatelessWidget {
  /// Creates an [AppBottomNav].
  const AppBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    super.key,
  });

  /// Currently selected index.
  final int currentIndex;

  /// Called when an item is tapped.
  final ValueChanged<int> onTap;

  /// Navigation items.
  final List<AppBottomNavItem> items;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppBlur.medium,
          sigmaY: AppBlur.medium,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant
                .withValues(alpha: AppOpacity.opaque - 0.05),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: items
                .asMap()
                .entries
                .map(
                  (entry) => BottomNavigationBarItem(
                    icon: Icon(entry.value.icon),
                    activeIcon: AnimatedScale(
                      scale: 1.15,
                      duration: AppMotion.fast,
                      curve: AppMotion.defaultCurve,
                      child: Icon(
                        entry.value.activeIcon,
                        shadows: AppShadows.primaryGlow,
                      ),
                    ),
                    label: entry.value.label,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
