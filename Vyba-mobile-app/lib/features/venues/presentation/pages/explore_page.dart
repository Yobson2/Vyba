import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/loading/app_shimmer.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_list_notifier.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_list_state.dart';
import 'package:flutter_templates/features/venues/presentation/widgets/venue_card.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  static const _filterChips = [
    'Open Now',
    'Top Rated',
    'Live Music',
    'VIP',
    'Nearby',
    'Promo Active',
  ];

  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _nearbyActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _isSearching = !_isSearching);
    if (!_isSearching && _searchController.text.isNotEmpty) {
      _searchController.clear();
      ref.read(venueListNotifierProvider.notifier).search('');
    }
  }

  void _onNearbyTap() {
    setState(() => _nearbyActive = !_nearbyActive);
    if (_nearbyActive) {
      ref.read(venueListNotifierProvider.notifier).useNearbyMe();
    } else {
      ref.read(venueListNotifierProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final venueState = ref.watch(venueListNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Glassmorphic App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: ClipRect(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppGradients.glassmorphicHeader,
                ),
              ),
            ),
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: GoogleFonts.epilogue(
                      fontSize: 14,
                      color: AppColors.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Rechercher un lieu, une adresse…',
                      hintStyle: TextStyle(
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => ref
                        .read(venueListNotifierProvider.notifier)
                        .search(value),
                  )
                : Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Abidjan',
                        style: GoogleFonts.epilogue(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
            actions: [
              // View toggle
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: AppRadius.borderRadiusFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ToggleButton(
                        icon: Icons.view_list, isActive: true, onTap: () {}),
                    const SizedBox(width: 4),
                    _ToggleButton(
                        icon: Icons.map_outlined,
                        isActive: false,
                        onTap: () {}),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search,
                    color: AppColors.onSurface),
                onPressed: _toggleSearch,
              ),
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.onSurface),
                onPressed: () {},
              ),
            ],
          ),
          // "DISCOVER NOW" subtitle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Text(
                'DISCOVER NOW',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 3,
                    ),
              ),
            ),
          ),
          // Filter chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filterChips.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = _filterChips[index];
                  final isNearby = label == 'Nearby';
                  final selected = isNearby ? _nearbyActive : index == 0;
                  return FilterChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: isNearby ? (_) => _onNearbyTap() : (_) {},
                    selectedColor: AppColors.primary,
                    labelStyle:
                        Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: selected
                                  ? AppColors.onPrimaryFixed
                                  : AppColors.onSurfaceVariant,
                            ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          // Venue list
          switch (venueState) {
            VenueListLoading() => SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalXl,
                  child: Column(
                    children: List.generate(
                      3,
                      (_) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AppShimmer(
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: AppRadius.borderRadiusMd,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            VenueListLoaded(:final venues) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList.builder(
                  itemCount: venues.length + 1, // +1 for VIP promo card
                  itemBuilder: (context, index) {
                    if (index == 2) {
                      // Insert VIP promo card after 2nd venue
                      return _VipPromoCard();
                    }
                    final venueIndex = index > 2 ? index - 1 : index;
                    if (venueIndex >= venues.length) {
                      return const SizedBox.shrink();
                    }
                    final venue = venues[venueIndex];
                    return VenueCard(
                      venue: venue,
                      onTap: () => context.push('/explore/venue/${venue.id}'),
                    );
                  },
                ),
              ),
            VenueListError(:final message) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => ref
                            .read(venueListNotifierProvider.notifier)
                            .refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            VenueListInitial() =>
              const SliverToBoxAdapter(child: SizedBox.shrink()),
          },
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      // Map toggle FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.surfaceContainerHighest,
        child: const Icon(Icons.map_outlined, color: AppColors.primary),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.borderRadiusFull,
        ),
        child: Icon(icon,
            size: 16,
            color: isActive
                ? AppColors.onPrimaryFixed
                : AppColors.onSurfaceVariant),
      ),
    );
  }
}

class _VipPromoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryButton,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PREMIUM MEMBER ACCESS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'VIP PASS\nExclusive',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Skip the line and get complimentary drinks at Velvet.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.tertiaryFixed,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: const Icon(Icons.diamond_outlined,
                color: AppColors.onTertiaryFixed),
          ),
        ],
      ),
    );
  }
}
