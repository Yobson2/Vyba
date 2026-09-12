import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_notifier.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_providers.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/my_opt_ins_provider.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_preferences_notifier.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_preferences_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Préférences de notification" (ticket 15 / spec 08) — the digest and
/// going-reminder toggles, plus (ticket 17) "mes lieux avec notifications" —
/// the per-venue broadcast opt-ins, managed here too since the venue page
/// toggle is easy to forget about afterwards.
class NotificationPreferencesPage extends ConsumerWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationPreferencesNotifierProvider);
    final notifier = ref.read(notificationPreferencesNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Préférences de notification',
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: switch (state) {
        NotificationPreferencesLoading() => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        NotificationPreferencesError(:final message) =>
          Center(child: Text(message)),
        NotificationPreferencesLoaded(:final preferences) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.verticalLg,
                Text(
                  'Voici les notifications que Vyba envoie pendant la validation.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                AppSpacing.verticalLg,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Le week-end à Zone 4'),
                        subtitle: const Text(
                          'Un rappel le jeudi soir de ce qui se passe ce week-end',
                        ),
                        value: preferences.weekendDigest,
                        onChanged: notifier.setWeekendDigest,
                      ),
                      SwitchListTile(
                        title: const Text('Rappel "J\'y vais"'),
                        subtitle: const Text(
                          'Un rappel en soirée pour les lieux que tu as marqués ce soir',
                        ),
                        value: preferences.goingReminder,
                        onChanged: notifier.setGoingReminder,
                      ),
                    ],
                  ),
                ),
                AppSpacing.verticalLg,
                Text(
                  'Mes lieux avec notifications',
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                AppSpacing.verticalSm,
                const _MyOptInsList(),
              ],
            ),
          ),
      },
    );
  }
}

class _MyOptInsList extends ConsumerWidget {
  const _MyOptInsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venuesAsync = ref.watch(myOptInsProvider);

    return venuesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (error, stackTrace) => Text(
        'Impossible de charger vos lieux.',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.error),
      ),
      data: (venues) {
        if (venues.isEmpty) {
          return Text(
            "Aucun lieu pour l'instant — active-le depuis la page d'un lieu.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          );
        }
        return Column(
          children: [
            for (final venue in venues)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                child: ListTile(
                  title: Text(venue.name),
                  trailing: TextButton(
                    onPressed: () async {
                      final result =
                          await ref.read(optOutUseCaseProvider).call(venue.id);
                      result.fold(
                        (failure) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(failure.message)),
                            );
                          }
                        },
                        (_) {
                          ref.read(myOptInsProvider.notifier).refresh();
                          if (ref.exists(
                            broadcastOptInNotifierProvider(venue.id),
                          )) {
                            ref.invalidate(
                              broadcastOptInNotifierProvider(venue.id),
                            );
                          }
                        },
                      );
                    },
                    child: const Text('Retirer'),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
