import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/extensions/live_since_extension.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/going/presentation/providers/owner_going_summary_provider.dart';
import 'package:flutter_templates/features/owner_broadcast/presentation/widgets/owner_broadcast_action.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_notifier.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_state.dart';
import 'package:google_fonts/google_fonts.dart';

/// Owner home: "on est live ce soir" toggle + headline field (ticket 06).
class LiveTonightCard extends ConsumerStatefulWidget {
  const LiveTonightCard({super.key});

  @override
  ConsumerState<LiveTonightCard> createState() => _LiveTonightCardState();
}

class _LiveTonightCardState extends ConsumerState<LiveTonightCard> {
  final _headlineController = TextEditingController();
  String? _syncedHeadline;
  bool _togglingLive = false;
  bool _savingHeadline = false;

  @override
  void dispose() {
    _headlineController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleLive() async {
    setState(() => _togglingLive = true);
    final error =
        await ref.read(venueNightNotifierProvider.notifier).toggleLive();
    if (!mounted) return;
    setState(() => _togglingLive = false);
    if (error != null) _showError(error);
  }

  Future<void> _saveHeadline() async {
    final text = _headlineController.text.trim();
    setState(() => _savingHeadline = true);
    final error = await ref
        .read(venueNightNotifierProvider.notifier)
        .updateHeadline(headline: text.isEmpty ? null : text);
    if (!mounted) return;
    setState(() => _savingHeadline = false);
    if (error != null) {
      _showError(error);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mis à jour.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(venueNightNotifierProvider);

    ref.listen<VenueNightState>(venueNightNotifierProvider, (_, next) {
      if (next is VenueNightLoaded &&
          _syncedHeadline != next.tonight.headline) {
        _syncedHeadline = next.tonight.headline;
        _headlineController.text = next.tonight.headline ?? '';
      }
    });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: switch (state) {
        VenueNightLoading() => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        VenueNightError(:final message) => Text(
            message.isEmpty ? 'Impossible de charger votre venue.' : message,
            style: TextStyle(color: AppColors.error),
          ),
        VenueNightLoaded(:final venue, :final tonight) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue.name,
                          style: GoogleFonts.epilogue(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tonight.isLive
                              ? "C'est live${tonight.liveSince != null ? ' · ${tonight.liveSince!.liveSinceLabel}' : ''}"
                              : 'On est live ce soir ?',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: tonight.isLive
                                        ? AppColors.success
                                        : AppColors.onSurfaceVariant,
                                    fontWeight:
                                        tonight.isLive ? FontWeight.w700 : null,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  _togglingLive
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Switch(
                          value: tonight.isLive,
                          onChanged: (_) => _toggleLive(),
                          activeColor: AppColors.success,
                        ),
                ],
              ),
              AppSpacing.verticalMd,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _headlineController,
                      decoration: const InputDecoration(
                        hintText: 'DJ Kobo ce soir...',
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _saveHeadline(),
                    ),
                  ),
                  AppSpacing.horizontalSm,
                  _savingHeadline
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.check_rounded),
                          color: AppColors.primary,
                          onPressed: _saveHeadline,
                        ),
                ],
              ),
              AppSpacing.verticalMd,
              _GoingSummaryRow(
                  venueId: venue.id, goingCount: tonight.goingCount),
              AppSpacing.verticalMd,
              const OwnerBroadcastAction(),
            ],
          ),
      },
    );
  }
}

/// Going count + rough party sizes — texture only, no approve/respond action
/// and no identity (ticket 08).
class _GoingSummaryRow extends ConsumerWidget {
  const _GoingSummaryRow({required this.venueId, required this.goingCount});

  final String venueId;
  final int goingCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partySizesAsync = ref.watch(ownerGoingSummaryProvider(venueId));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.groups_outlined,
            size: 18, color: AppColors.onSurfaceVariant),
        AppSpacing.horizontalSm,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$goingCount y vont ce soir',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              partySizesAsync.when(
                data: (sizes) => sizes.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        'Groupes : ${sizes.join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
