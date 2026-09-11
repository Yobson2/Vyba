import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/data_display/app_image_carousel.dart';
import 'package:flutter_templates/core/widgets/data_display/app_rating_badge.dart';
import 'package:flutter_templates/core/widgets/data_display/app_status_chip.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_detail_notifier.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_detail_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class VenueDetailPage extends ConsumerWidget {
  const VenueDetailPage({required this.venueId, super.key});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(venueDetailNotifierProvider(venueId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: switch (state) {
        VenueDetailLoading() => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        VenueDetailError(:final message) => Center(child: Text(message)),
        VenueDetailLoaded(:final venue) => Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Hero Image Carousel
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        AppImageCarousel(
                          imageUrls: venue.heroImages,
                          height: 320,
                        ),
                        // Back & actions
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          left: 8,
                          child: IconButton(
                            onPressed: () => context.pop(),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.black.withValues(alpha: 0.3),
                            ),
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          right: 8,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Colors.black.withValues(alpha: 0.3),
                                ),
                                icon: const Icon(Icons.share_outlined,
                                    color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {},
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Colors.black.withValues(alpha: 0.3),
                                ),
                                icon: const Icon(Icons.favorite_border,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Floating info card
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ClipRRect(
                          borderRadius: AppRadius.borderRadiusMd,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.glassBg,
                                borderRadius: AppRadius.borderRadiusMd,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (venue.isPremium)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        'PREMIUM VENUE',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: AppColors.tertiaryFixed,
                                              letterSpacing: 2,
                                            ),
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          venue.name,
                                          style: GoogleFonts.epilogue(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                      ),
                                      AppRatingBadge(
                                        rating: venue.rating,
                                        reviewCount: venue.reviewCount,
                                      ),
                                    ],
                                  ),
                                  AppSpacing.verticalSm,
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 16,
                                          color: AppColors.onSurfaceVariant),
                                      const SizedBox(width: 4),
                                      Text(
                                        venue.address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                      ),
                                      const Spacer(),
                                      AppStatusChip(
                                        label: venue.isOpen
                                            ? 'OPEN NOW'
                                            : 'CLOSED',
                                        status: venue.isOpen
                                            ? VenueStatus.open
                                            : VenueStatus.closed,
                                      ),
                                    ],
                                  ),
                                  AppSpacing.verticalLg,
                                  // Quick actions
                                  Row(
                                    children: [
                                      _QuickAction(
                                        icon: Icons.calendar_today,
                                        label: 'Reserve',
                                        onTap: () {},
                                      ),
                                      const SizedBox(width: 12),
                                      _QuickAction(
                                        icon: Icons.phone_outlined,
                                        label: 'Call',
                                        onTap: () {},
                                      ),
                                      const SizedBox(width: 12),
                                      _QuickAction(
                                        icon: Icons.directions_outlined,
                                        label: 'Go',
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // About section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('The Experience',
                              style: Theme.of(context).textTheme.titleLarge),
                          AppSpacing.verticalSm,
                          Text(
                            venue.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.6,
                                ),
                          ),
                          AppSpacing.verticalXl,
                          // Amenities
                          if (venue.amenities.isNotEmpty) ...[
                            Text('Amenities',
                                style: Theme.of(context).textTheme.titleMedium),
                            AppSpacing.verticalMd,
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: venue.amenities
                                  .map((a) => Chip(
                                        label: Text(a),
                                        avatar: Icon(
                                          _amenityIcon(a),
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                          AppSpacing.verticalXl,
                          // Gallery
                          Text('Gallery',
                              style: Theme.of(context).textTheme.titleMedium),
                          AppSpacing.verticalMd,
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: venue.heroImages.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: AppRadius.borderRadiusSm,
                                  child: Image.network(
                                    venue.heroImages[index],
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Sticky Reserve button
              Positioned(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 16,
                child: AppGradientButton(
                  onPressed: () {},
                  label: 'RESERVE A TABLE',
                  icon: Icons.arrow_forward,
                ),
              ),
            ],
          ),
      },
    );
  }

  IconData _amenityIcon(String amenity) {
    return switch (amenity.toLowerCase()) {
      'wifi' => Icons.wifi,
      'parking' => Icons.local_parking,
      'outdoor deck' || 'outdoor seating' => Icons.deck,
      'full kitchen' => Icons.restaurant,
      'vip booths' => Icons.star,
      'live music' => Icons.music_note,
      'beach access' => Icons.beach_access,
      'full bar' => Icons.local_bar,
      'lounge seating' => Icons.weekend,
      'dance floor' => Icons.nightlife,
      'private dining' => Icons.dining,
      _ => Icons.check_circle_outline,
    };
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: AppRadius.borderRadiusSm,
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
