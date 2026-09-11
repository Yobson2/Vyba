import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:flutter_templates/features/going/presentation/providers/going_notifier.dart';
import 'package:flutter_templates/features/going/presentation/providers/going_state.dart';

/// "J'y vais" button + state for one venue's venue-detail page (ticket 08).
class GoingSection extends ConsumerWidget {
  const GoingSection({required this.venueId, super.key});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goingNotifierProvider(venueId));
    final notifier = ref.read(goingNotifierProvider(venueId).notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: switch (state) {
        GoingLoading() => const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        GoingOwnedVenue() => Row(
            children: [
              const Icon(Icons.storefront_outlined,
                  size: 18, color: AppColors.onSurfaceVariant),
              AppSpacing.horizontalSm,
              const Expanded(
                child: Text(
                  "C'est ton établissement — tu ne peux pas marquer \"J'y vais\" ici.",
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        GoingOffline() => _RetryRow(
            icon: Icons.wifi_off_outlined,
            message: 'Connexion requise pour dire "J\'y vais".',
            onRetry: () => notifier.mark(),
          ),
        GoingErrorState(:final message) => _RetryRow(
            icon: Icons.error_outline,
            message: message,
            onRetry: () => notifier.mark(),
          ),
        GoingNotMarked() => SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => notifier.mark(),
              icon: const Icon(Icons.celebration_outlined),
              label: const Text("J'y vais ce soir"),
            ),
          ),
        GoingMarked(:final going) =>
          _MarkedControls(going: going, notifier: notifier),
      },
    );
  }
}

class _RetryRow extends StatelessWidget {
  const _RetryRow({
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        AppSpacing.horizontalSm,
        Expanded(
          child: Text(message,
              style: const TextStyle(color: AppColors.onSurfaceVariant)),
        ),
        TextButton(onPressed: onRetry, child: const Text('Réessayer')),
      ],
    );
  }
}

class _MarkedControls extends StatelessWidget {
  const _MarkedControls({required this.going, required this.notifier});

  final Going going;
  final GoingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 20),
            AppSpacing.horizontalSm,
            const Text(
              "J'y vais ✓",
              style: TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: notifier.cancel,
              child: const Text('Annuler'),
            ),
          ],
        ),
        AppSpacing.verticalSm,
        Row(
          children: [
            const Text('On sera : '),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed: going.partySize > 1
                  ? () => notifier.update(partySize: going.partySize - 1)
                  : null,
            ),
            Text(
              '${going.partySize}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: going.partySize < 20
                  ? () => notifier.update(partySize: going.partySize + 1)
                  : null,
            ),
          ],
        ),
        InkWell(
          onTap: () => notifier.update(identityPublic: !going.identityPublic),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: going.identityPublic,
                onChanged: (v) => notifier.update(identityPublic: v ?? false),
              ),
              const Text("Montrer que c'est moi"),
            ],
          ),
        ),
      ],
    );
  }
}
