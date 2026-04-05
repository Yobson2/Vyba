import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';

/// Star + rating number display badge.
class AppRatingBadge extends StatelessWidget {
  const AppRatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = RatingBadgeSize.medium,
  });

  final double rating;
  final int? reviewCount;
  final RatingBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final textStyle = size == RatingBadgeSize.small
        ? Theme.of(context).textTheme.labelSmall
        : Theme.of(context).textTheme.labelLarge;
    final iconSize = size == RatingBadgeSize.small ? 14.0 : 18.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.tertiaryFixed, size: iconSize),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: textStyle?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }
}

enum RatingBadgeSize { small, medium }
