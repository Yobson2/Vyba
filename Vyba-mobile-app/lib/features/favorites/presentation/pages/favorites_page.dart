import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_templates/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bento-grid layout displaying the user's favorited venues.
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Favorites',
          style: GoogleFonts.epilogue(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: favoritesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (favorites) => _FavoritesGrid(favorites: favorites),
      ),
    );
  }
}

class _FavoritesGrid extends ConsumerWidget {
  const _FavoritesGrid({required this.favorites});

  final List<Favorite> favorites;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_outline,
              size: 64,
              color: AppColors.onSurfaceVariant,
            ),
            AppSpacing.verticalLg,
            Text(
              'No favorites yet',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalSm,
            const Text(
              'Tap the heart icon on any venue to save it here.',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Featured card (16:10 aspect ratio, full width)
          if (favorites.isNotEmpty)
            _FeaturedCard(favorite: favorites.first, ref: ref),

          AppSpacing.verticalLg,

          // Standard cards in a 2-column grid (4:5 aspect ratio)
          if (favorites.length > 1)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4 / 5,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              itemCount: (favorites.length - 1).clamp(0, 3),
              itemBuilder: (context, index) {
                return _StandardCard(
                  favorite: favorites[index + 1],
                  ref: ref,
                );
              },
            ),

          AppSpacing.verticalLg,

          // Discover More promo card
          _DiscoverMoreCard(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Featured card — 16:10, 2 columns wide
// ---------------------------------------------------------------------------
class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.favorite, required this.ref});

  final Favorite favorite;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ClipRRect(
        borderRadius: AppRadius.borderRadiusLg,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(
              favorite.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceContainerHigh,
              ),
            ),

            // Scrim overlay
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.scrimOverlay),
            ),

            // Heart icon (top-right)
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: GestureDetector(
                onTap: () => ref
                    .read(favoriteToggleProvider.notifier)
                    .toggle(favorite.venueId),
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.error,
                  size: 28,
                ),
              ),
            ),

            // Content overlay
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          favorite.address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Name
                  Text(
                    favorite.name,
                    style: GoogleFonts.epilogue(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.verticalSm,
                  // Rating + Quick Book row
                  Row(
                    children: [
                      _StarRating(rating: favorite.rating),
                      const Spacer(),
                      SizedBox(
                        width: 120,
                        height: 36,
                        child: AppGradientButton(
                          onPressed: () {},
                          label: 'Quick Book',
                          height: 36,
                          width: 120,
                          borderRadius: AppRadius.borderRadiusSm,
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

// ---------------------------------------------------------------------------
// Standard card — 4:5 aspect ratio
// ---------------------------------------------------------------------------
class _StandardCard extends StatelessWidget {
  const _StandardCard({required this.favorite, required this.ref});

  final Favorite favorite;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.borderRadiusMd,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            favorite.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surfaceContainerHigh,
            ),
          ),

          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.scrimOverlay),
          ),

          // Heart icon
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: GestureDetector(
              onTap: () => ref
                  .read(favoriteToggleProvider.notifier)
                  .toggle(favorite.venueId),
              child: const Icon(
                Icons.favorite,
                color: AppColors.error,
                size: 22,
              ),
            ),
          ),

          // Content
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        favorite.address,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  favorite.name,
                  style: GoogleFonts.epilogue(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _StarRating(rating: favorite.rating, size: 12),
                AppSpacing.verticalSm,
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: AppGradientButton(
                    onPressed: () {},
                    label: 'Quick Book',
                    height: 32,
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Discover More promo card
// ---------------------------------------------------------------------------
class _DiscoverMoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingXl,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryButton,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.explore_outlined,
            size: 40,
            color: AppColors.onPrimaryFixed,
          ),
          AppSpacing.verticalMd,
          Text(
            'Discover More',
            style: GoogleFonts.epilogue(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onPrimaryFixed,
            ),
          ),
          AppSpacing.verticalSm,
          const Text(
            'Explore trending venues and find your next favorite spot.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onPrimaryFixed,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Star rating helper
// ---------------------------------------------------------------------------
class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, this.size = 16});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: AppColors.tertiary, size: size),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size - 2,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
