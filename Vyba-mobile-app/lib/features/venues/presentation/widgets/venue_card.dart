import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/widgets/data_display/app_rating_badge.dart';
import 'package:flutter_templates/core/widgets/data_display/app_status_chip.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({
    super.key,
    required this.venue,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  final Venue venue;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: AppRadius.borderRadiusMd,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Hero image
                Image.network(
                  venue.firstImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceContainerHigh,
                    child: const Icon(Icons.nightlife,
                        color: AppColors.outline, size: 48),
                  ),
                ),
                // Scrim overlay
                const DecoratedBox(
                  decoration:
                      BoxDecoration(gradient: AppGradients.scrimOverlay),
                ),
                // Status chip (top-left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: AppStatusChip(
                    label: venue.isOpen ? 'Open Now' : 'Closed',
                    status:
                        venue.isOpen ? VenueStatus.open : VenueStatus.closed,
                  ),
                ),
                // Promo badge (if active)
                if (venue.activePromoLabel != null)
                  Positioned(
                    top: 12,
                    left: venue.isOpen ? 110 : 90,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            AppColors.tertiaryContainer.withValues(alpha: 0.9),
                        borderRadius: AppRadius.borderRadiusFull,
                      ),
                      child: Text(
                        venue.activePromoLabel!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onTertiaryFixed,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                      ),
                    ),
                  ),
                // Favorite button (top-right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: onFavoriteTap,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? AppColors.error
                          : AppColors.onSurface.withValues(alpha: 0.8),
                      size: 22,
                    ),
                  ),
                ),
                // Bottom content
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        venue.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.7)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${venue.address} ${venue.formattedDistance.isNotEmpty ? '• ${venue.formattedDistance}' : ''}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppRatingBadge(
                            rating: venue.rating,
                            reviewCount: venue.reviewCount,
                            size: RatingBadgeSize.small,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
