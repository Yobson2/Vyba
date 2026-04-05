import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/reviews/domain/entities/review.dart';
import 'package:intl/intl.dart';

/// Display card for a single review, styled for venue detail pages.
class ReviewCard extends StatelessWidget {
  const ReviewCard({required this.review, super.key});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header: avatar, name, date ---
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review.userAvatar),
                backgroundColor: AppColors.surfaceContainerHighest,
              ),
              AppSpacing.horizontalMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(review.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppSpacing.verticalMd,

          // --- Star rating ---
          Row(
            children: List.generate(5, (index) {
              final starValue = index + 1.0;
              return Icon(
                starValue <= review.rating
                    ? Icons.star_rounded
                    : (starValue - 0.5 <= review.rating
                        ? Icons.star_half_rounded
                        : Icons.star_outline_rounded),
                size: 18,
                color: AppColors.tertiary,
              );
            }),
          ),

          AppSpacing.verticalMd,

          // --- Review text ---
          Text(
            review.text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
