import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/extensions/live_since_extension.dart';
import 'package:flutter_templates/core/providers/analytics_provider.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/utils/maps_launcher.dart';
import 'package:flutter_templates/core/widgets/data_display/app_image_carousel.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/widgets/broadcast_opt_in_toggle.dart';
import 'package:flutter_templates/features/follow/presentation/widgets/follow_button.dart';
import 'package:flutter_templates/features/going/presentation/widgets/going_section.dart';
import 'package:flutter_templates/features/media/presentation/widgets/night_photos_section.dart';
import 'package:flutter_templates/features/reservations/presentation/widgets/reservation_section.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_promo.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_detail_notifier.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_detail_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueDetailPage extends ConsumerStatefulWidget {
  const VenueDetailPage({required this.venueId, super.key});

  final String venueId;

  @override
  ConsumerState<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends ConsumerState<VenueDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logEvent('venue_viewed', {
      'venue_id': widget.venueId,
    });
  }

  Future<void> _openInMaps(BuildContext context, Venue venue) async {
    final uri = buildGoogleMapsUri(venue.latitude, venue.longitude);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir Google Maps.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final venueId = widget.venueId;
    final state = ref.watch(venueDetailNotifierProvider(venueId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: switch (state) {
        VenueDetailLoading() => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        VenueDetailError(:final message) => Center(child: Text(message)),
        VenueDetailLoaded(:final venue) => CustomScrollView(
            slivers: [
              // Hero Image Carousel
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    AppImageCarousel(
                      imageUrls: venue.heroImages,
                      height: 320,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 8,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.3),
                        ),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  FollowButton(venueId: venue.id),
                                ],
                              ),
                              AppSpacing.verticalXs,
                              Row(
                                children: [
                                  Text(
                                    _venueTypeLabel(venue.venueType),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  ),
                                  const Text(' · '),
                                  Text(
                                    venue.priceLevelLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  ),
                                  if (venue.followerCount > 0) ...[
                                    const Text(' · '),
                                    Text(
                                      '${venue.followerCount} abonnés',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                              AppSpacing.verticalSm,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 16,
                                      color: AppColors.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      venue.address,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              AppSpacing.verticalSm,
                              OutlinedButton.icon(
                                onPressed: () => _openInMaps(context, venue),
                                icon: const Icon(Icons.map_outlined, size: 18),
                                label: const Text('Ouvrir dans Google Maps'),
                              ),
                              AppSpacing.verticalLg,
                              _TonightBlock(
                                tonight: venue.tonight,
                                occupancyLevel: venue.occupancyLevel,
                              ),
                              AppSpacing.verticalMd,
                              GoingSection(venueId: venue.id),
                              if (venue.reservationsEnabled) ...[
                                AppSpacing.verticalSm,
                                ReservationSection(venueId: venue.id),
                              ],
                              AppSpacing.verticalSm,
                              BroadcastOptInToggle(venueId: venue.id),
                              if (venue.promos.isNotEmpty) ...[
                                AppSpacing.verticalMd,
                                _PromoSection(promos: venue.promos),
                              ],
                              AppSpacing.verticalMd,
                              NightPhotosSection(venueId: venue.id),
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
                      if (venue.description.isNotEmpty) ...[
                        Text('À propos',
                            style: Theme.of(context).textTheme.titleLarge),
                        AppSpacing.verticalSm,
                        Text(
                          venue.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    height: 1.6,
                                  ),
                        ),
                        AppSpacing.verticalXl,
                      ],
                      if (venue.heroImages.length > 1) ...[
                        Text('Galerie',
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
                      ],
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
      },
    );
  }

  String _venueTypeLabel(VenueType type) => switch (type) {
        VenueType.club => 'Club',
        VenueType.bar => 'Bar',
        VenueType.lounge => 'Lounge',
        VenueType.maquis => 'Maquis',
      };
}

/// Active promotions section (ticket 09) — distinct from the tonight/going
/// blocks, Golden Hour tinted to match the promo/VIP brand color.
class _PromoSection extends StatelessWidget {
  const _PromoSection({required this.promos});

  final List<VenuePromo> promos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final promo in promos) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_offer_rounded,
                        size: 16, color: AppColors.tertiary),
                    const SizedBox(width: 6),
                    Text(
                      promo.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                if (promo.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    promo.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (promo != promos.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

/// Live status + headline, or "rien d'annoncé ce soir" when there's no
/// activity tonight (spec 02 / ADR-0001: tonight's state is never inferred,
/// only ever `VenueNight` or absent).
class _TonightBlock extends StatelessWidget {
  const _TonightBlock({required this.tonight, this.occupancyLevel});

  final VenueTonight? tonight;
  final OccupancyLevel? occupancyLevel;

  @override
  Widget build(BuildContext context) {
    if (tonight == null || !tonight!.isLive) {
      final goingCount = tonight?.goingCount ?? 0;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: AppRadius.borderRadiusSm,
        ),
        child: Row(
          children: [
            const Icon(Icons.nightlight_outlined,
                size: 16, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Rien d'annoncé ce soir",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ),
            if (occupancyLevel != null) ...[
              _OccupancyChip(level: occupancyLevel!),
              const SizedBox(width: 8),
            ],
            if (goingCount > 0)
              Text(
                '$goingCount y vont',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
              ),
          ],
        ),
      );
    }

    final night = tonight!;
    final parts = <String>[
      "C'est live",
      if (night.liveSince != null) night.liveSince!.liveSinceLabel,
      if (night.headline != null && night.headline!.isNotEmpty)
        night.headline!
      else if (night.djName != null && night.djName!.isNotEmpty)
        night.djName!,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: AppRadius.borderRadiusSm,
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              parts.join(' · '),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          if (occupancyLevel != null) ...[
            _OccupancyChip(level: occupancyLevel!),
            const SizedBox(width: 8),
          ],
          if (night.goingCount > 0)
            Text(
              '${night.goingCount} y vont',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
        ],
      ),
    );
  }
}

/// Quiet/busy/full gauge from `capacity` vs. tonight's going count — a rough
/// signal, not an exact seat count.
class _OccupancyChip extends StatelessWidget {
  const _OccupancyChip({required this.level});

  final OccupancyLevel level;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (level) {
      OccupancyLevel.quiet => ('Calme', AppColors.success),
      OccupancyLevel.busy => ('Animé', AppColors.onSurfaceVariant),
      OccupancyLevel.full => ('Complet', AppColors.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
