import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/loading/app_shimmer.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';
import 'package:flutter_templates/features/feed/presentation/providers/feed_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Pull-to-refresh feed with promo and event cards.
class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  List<FeedItem>? _feedItems;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final repository = ref.read(feedRepositoryProvider);
    final result = await repository.getFeed();

    if (!mounted) return;
    result.fold(
      (Failure failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (List<FeedItem> items) => setState(() {
        _feedItems = items;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Feed',
          style: GoogleFonts.epilogue(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: AppColors.error),
            ),
            AppSpacing.verticalMd,
            TextButton(
              onPressed: _loadFeed,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final items = _feedItems ?? [];
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No feed items yet',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFeed,
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceContainerHigh,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: items.length,
        separatorBuilder: (_, __) => AppSpacing.verticalLg,
        itemBuilder: (context, index) {
          final item = items[index];
          return switch (item) {
            PromoFeedItem() => _PromoCard(promo: item),
            EventFeedItem() => _EventCard(
                event: item,
                onInterested: () => _toggleInterested(item.id),
              ),
          };
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: 4,
      separatorBuilder: (_, __) => AppSpacing.verticalLg,
      itemBuilder: (_, index) {
        final isPromo = index.isEven;
        return AppShimmer(
          height: isPromo ? 240 : 320,
          borderRadius: AppRadius.borderRadiusMd,
        );
      },
    );
  }

  Future<void> _toggleInterested(String eventId) async {
    final repository = ref.read(feedRepositoryProvider);
    await repository.markInterested(eventId);
    await _loadFeed();
  }
}

// ── Promo Card ───────────��─────────────────────────────────────────

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo});

  final PromoFeedItem promo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.borderRadiusMd,
      child: SizedBox(
        height: 240,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-bleed image
            Image.network(
              promo.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceContainerHigh,
              ),
            ),
            // Scrim overlay
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.scrimOverlay),
            ),
            // Content
            Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Promo badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppGradients.tertiaryPromo,
                      borderRadius: AppRadius.borderRadiusXs,
                    ),
                    child: Text(
                      promo.promoType.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.onTertiaryFixed,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    promo.title,
                    style: GoogleFonts.epilogue(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.verticalXs,
                  Text(
                    promo.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.verticalSm,
                  Row(
                    children: [
                      Text(
                        promo.venueName,
                        style: const TextStyle(
                          color: AppColors.tertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (promo.validUntil != null) _buildCountdown(),
                    ],
                  ),
                  AppSpacing.verticalMd,
                  SizedBox(
                    height: 36,
                    child: AppGradientButton(
                      onPressed: () {
                        // Navigate to promo details
                      },
                      label: 'View Promo',
                      height: 36,
                      width: 120,
                      borderRadius: AppRadius.borderRadiusFull,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    final remaining = promo.validUntil!.difference(DateTime.now());
    final text = remaining.isNegative
        ? 'Expired'
        : remaining.inDays > 0
            ? '${remaining.inDays}d left'
            : '${remaining.inHours}h left';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer_outlined, size: 14, color: AppColors.tertiary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.tertiary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Event Card ──────────────────────────���──────────────────────────

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.onInterested,
  });

  final EventFeedItem event;
  final VoidCallback onInterested;

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('EEE, dd MMM').format(event.date);

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusMd,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceContainerHigh,
              ),
            ),
            // Scrim
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.scrimOverlay),
            ),
            // Date badge (top-left)
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer.withValues(alpha: 0.85),
                  borderRadius: AppRadius.borderRadiusXs,
                ),
                child: Text(
                  dateFormatted,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Favorite heart (top-right)
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: GestureDetector(
                onTap: onInterested,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    event.isInterested
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: event.isInterested
                        ? AppColors.error
                        : AppColors.onSurface,
                    size: 18,
                  ),
                ),
              ),
            ),
            // Bottom content
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.title,
                    style: GoogleFonts.epilogue(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.verticalXs,
                  Text(
                    event.venueName,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.verticalMd,
                  Row(
                    children: [
                      // Avatar stack
                      if (event.attendeeAvatars.isNotEmpty)
                        _AppAvatarStack(avatarUrls: event.attendeeAvatars),
                      if (event.attendeeAvatars.isNotEmpty)
                        AppSpacing.horizontalSm,
                      Text(
                        '${event.attendeeCount} interested',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onInterested,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            gradient: event.isInterested
                                ? AppGradients.primaryButton
                                : null,
                            color: event.isInterested
                                ? null
                                : Colors.white.withValues(alpha: 0.15),
                            borderRadius: AppRadius.borderRadiusFull,
                          ),
                          child: Text(
                            event.isInterested ? 'Interested' : 'Interested?',
                            style: TextStyle(
                              color: event.isInterested
                                  ? AppColors.onPrimaryFixed
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar Stack ──────��────────────────────────────────────────────

class _AppAvatarStack extends StatelessWidget {
  const _AppAvatarStack({required this.avatarUrls});

  final List<String> avatarUrls;

  @override
  Widget build(BuildContext context) {
    const size = 24.0;
    const overlap = 8.0;
    final count = avatarUrls.length.clamp(0, 3);
    final width = count * (size - overlap) + overlap;

    return SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: List.generate(count, (index) {
          return Positioned(
            left: index * (size - overlap),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.background,
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  avatarUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primaryContainer,
                    child: const Icon(
                      Icons.person,
                      size: 12,
                      color: AppColors.onPrimaryContainer,
                    ),
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
