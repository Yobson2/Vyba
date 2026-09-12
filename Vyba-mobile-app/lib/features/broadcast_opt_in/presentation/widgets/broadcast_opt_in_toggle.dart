import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_notifier.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_state.dart';

/// "Recevoir les infos de ce lieu" (ticket 17 / spec 08) — a venue-page
/// toggle explicitly separate from following: opting in lets the venue send
/// its one-per-night broadcast to whoever marked "J'y vais" tonight.
class BroadcastOptInToggle extends ConsumerWidget {
  const BroadcastOptInToggle({required this.venueId, super.key});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(broadcastOptInNotifierProvider(venueId));
    final notifier = ref.read(broadcastOptInNotifierProvider(venueId).notifier);

    final isLoading = state is BroadcastOptInLoading;
    final isOn = state is BroadcastOptedIn;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Recevoir les infos de ce lieu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ),
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          Switch(value: isOn, onChanged: (_) => notifier.toggle()),
      ],
    );
  }
}
