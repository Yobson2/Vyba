import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/providers/analytics_provider.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/loading/app_shimmer.dart';
import 'package:flutter_templates/core/widgets/states/app_empty_state.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';
import 'package:flutter_templates/features/feed/presentation/providers/feed_notifier.dart';
import 'package:flutter_templates/features/feed/presentation/providers/feed_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// The Zone 4 feed — live-tonight and editorial cards, in the server's order.
class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final _scrollController = ScrollController();
  final _viewedItemIds = <String>{};

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logEvent('feed_opened');
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      ref.read(feedNotifierProvider.notifier).loadMore();
    }
  }

  void _onItemBuilt(FeedItem item) {
    if (_viewedItemIds.add(item.id)) {
      ref.read(analyticsServiceProvider).logEvent('feed_item_viewed', {
        'item_id': item.id,
        'item_type': item.runtimeType.toString(),
      });
    }
  }

  void _openVenue(String? venueId) {
    if (venueId == null) return;
    context.push('/explore/venue/$venueId');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Zone 4',
          style: GoogleFonts.epilogue(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: switch (state) {
        FeedLoading() => _buildShimmerLoading(),
        FeedError(:final message) => _buildError(message),
        FeedLoaded(:final items) when items.isEmpty => _buildEmpty(state),
        FeedLoaded() => _buildList(state),
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: AppColors.error)),
          AppSpacing.verticalMd,
          TextButton(
            onPressed: () => ref.read(feedNotifierProvider.notifier).refresh(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(FeedLoaded state) {
    return RefreshIndicator(
      onRefresh: () => ref.read(feedNotifierProvider.notifier).refresh(),
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceContainerHigh,
      child: ListView(
        children: [
          if (state.isFromCache) const _OfflineBanner(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const AppEmptyState(
              icon: Icons.nightlife_outlined,
              title: "C'est calme ce soir à Zone 4",
              subtitle:
                  'Revenez plus tard, ou explorez les venues du quartier.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(FeedLoaded state) {
    return RefreshIndicator(
      onRefresh: () => ref.read(feedNotifierProvider.notifier).refresh(),
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceContainerHigh,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: state.items.length +
            (state.isFromCache ? 1 : 0) +
            (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => AppSpacing.verticalLg,
        itemBuilder: (context, index) {
          if (state.isFromCache) {
            if (index == 0) return const _OfflineBanner();
            index -= 1;
          }
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          final item = state.items[index];
          _onItemBuilt(item);
          return switch (item) {
            LiveTonightFeedItem() => _LiveTonightCard(
                item: item,
                onTap: () => _openVenue(item.venueId),
              ),
            PromoFeedItem() => _PromoCard(
                item: item,
                onTap: () => _openVenue(item.venueId),
              ),
            EditorialFeedItem() => _EditorialCard(item: item),
            UnknownFeedItem() => const SizedBox.shrink(),
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
      itemBuilder: (_, __) => AppShimmer(
        height: 160,
        borderRadius: AppRadius.borderRadiusMd,
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: AppRadius.borderRadiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined,
              size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            'Hors ligne · dernière version affichée',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _LiveTonightCard extends StatelessWidget {
  const _LiveTonightCard({required this.item, required this.onTap});

  final LiveTonightFeedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            AppSpacing.horizontalMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EN CE MOMENT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.venueName ?? 'Une venue',
                    style: GoogleFonts.epilogue(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const Text(
                    "C'est live ce soir",
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// Distinct promo card (ticket 09) — Golden Hour is the promo/VIP-only
/// brand color (design system), so it's what sets this apart from the
/// live-tonight (success/emerald) and editorial (primary/indigo) cards.
class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.item, required this.onTap});

  final PromoFeedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.tertiary.withValues(alpha: 0.12),
          borderRadius: AppRadius.borderRadiusMd,
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
                  'PROMO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                ),
                const Spacer(),
                if (item.venueName != null)
                  Text(
                    item.venueName!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
            AppSpacing.verticalSm,
            Text(
              item.title,
              style: GoogleFonts.epilogue(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              style: const TextStyle(color: AppColors.onSurfaceVariant),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorialCard extends StatelessWidget {
  const _EditorialCard({required this.item});

  final EditorialFeedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_outlined,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'VYBA',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
              ),
              const Spacer(),
              Text(
                DateFormat('EEE HH:mm').format(item.publishedAt.toLocal()),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          AppSpacing.verticalSm,
          Text(
            item.title,
            style: GoogleFonts.epilogue(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.body,
            style: const TextStyle(color: AppColors.onSurfaceVariant),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
