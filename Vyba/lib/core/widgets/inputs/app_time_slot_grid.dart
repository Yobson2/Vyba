import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';

/// Grid of selectable time slot chips.
class AppTimeSlotGrid extends StatelessWidget {
  const AppTimeSlotGrid({
    super.key,
    required this.timeSlots,
    required this.selectedSlot,
    required this.onSlotSelected,
    this.crossAxisCount = 3,
  });

  final List<String> timeSlots;
  final String? selectedSlot;
  final ValueChanged<String> onSlotSelected;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.5,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        final isSelected = slot == selectedSlot;

        return GestureDetector(
          onTap: () => onSlotSelected(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.surfaceContainerHighest,
              borderRadius: AppRadius.borderRadiusSm,
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? AppColors.onPrimaryFixed
                        : AppColors.onSurface,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ),
        );
      },
    );
  }
}
