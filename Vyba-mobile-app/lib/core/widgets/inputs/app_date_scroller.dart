import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';

/// Horizontal scrollable day picker showing a week of dates.
class AppDateScroller extends StatelessWidget {
  const AppDateScroller({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.startDate,
    this.dayCount = 14,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? startDate;
  final int dayCount;

  static const _dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    final start = startDate ?? DateTime.now();
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dayCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = start.add(Duration(days: index));
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          final isToday = date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceContainerHighest,
                borderRadius: AppRadius.borderRadiusMd,
                border: isToday && !isSelected
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayNames[date.weekday - 1],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? AppColors.onPrimaryFixed
                              : AppColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isSelected
                              ? AppColors.onPrimaryFixed
                              : AppColors.onSurface,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
