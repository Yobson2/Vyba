import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';

/// Custom pill-indicator tab bar matching Lagos Pulse design.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadius.borderRadiusFull,
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? AppColors.onPrimaryFixed
                            : AppColors.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
