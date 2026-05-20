import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';

/// Overlapping circular avatars for attendee display.
class AppAvatarStack extends StatelessWidget {
  const AppAvatarStack({
    super.key,
    required this.imageUrls,
    this.maxDisplay = 3,
    this.size = 28,
    this.overlap = 8,
  });

  final List<String> imageUrls;
  final int maxDisplay;
  final double size;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final displayCount = imageUrls.length > maxDisplay ? maxDisplay : imageUrls.length;
    final remaining = imageUrls.length - displayCount;
    final totalWidth = size + (displayCount - 1 + (remaining > 0 ? 1 : 0)) * (size - overlap);

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: size / 2,
                  backgroundImage: NetworkImage(imageUrls[i]),
                  backgroundColor: AppColors.surfaceContainerHigh,
                ),
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: displayCount * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHighest,
                  border: Border.all(
                    color: AppColors.background,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: size * 0.35,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
