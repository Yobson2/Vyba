import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/states/app_empty_state.dart';
import 'package:flutter_templates/features/follow/domain/entities/followed_venue.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_notifier.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_providers.dart';
import 'package:flutter_templates/features/follow/presentation/providers/followed_venues_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Mes lieux suivis" (ticket 10) — inline unfollow, straight from the list.
class FollowedVenuesPage extends ConsumerWidget {
  const FollowedVenuesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venuesAsync = ref.watch(followedVenuesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Mes lieux suivis',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: venuesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => const Center(
          child: Text(
            'Impossible de charger vos lieux suivis.',
            style: TextStyle(color: AppColors.error),
          ),
        ),
        data: (venues) => venues.isEmpty
            ? const AppEmptyState(
                icon: Icons.notifications_outlined,
                title: 'Aucun lieu suivi',
                subtitle:
                    'Suivez un lieu depuis sa page pour le retrouver ici.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: venues.length,
                separatorBuilder: (_, __) => AppSpacing.verticalSm,
                itemBuilder: (context, index) =>
                    _FollowedVenueTile(venue: venues[index]),
              ),
      ),
    );
  }
}

class _FollowedVenueTile extends ConsumerWidget {
  const _FollowedVenueTile({required this.venue});

  final FollowedVenue venue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: AppRadius.borderRadiusMd,
      child: InkWell(
        borderRadius: AppRadius.borderRadiusMd,
        onTap: () => context.push('/explore/venue/${venue.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.borderRadiusSm,
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: venue.firstPhoto.isEmpty
                      ? const ColoredBox(
                          color: AppColors.surfaceContainerHighest,
                          child: Icon(
                            Icons.nightlife,
                            color: AppColors.outline,
                          ),
                        )
                      : Image.network(venue.firstPhoto, fit: BoxFit.cover),
                ),
              ),
              AppSpacing.horizontalMd,
              Expanded(
                child: Text(
                  venue.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final result = await ref
                      .read(unfollowVenueUseCaseProvider)
                      .call(venue.id);
                  result.fold(
                    (failure) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(failure.message)),
                        );
                      }
                    },
                    (_) {
                      ref.read(followedVenuesProvider.notifier).refresh();
                      if (ref.exists(followNotifierProvider(venue.id))) {
                        ref.invalidate(followNotifierProvider(venue.id));
                      }
                    },
                  );
                },
                child: const Text('Ne plus suivre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
