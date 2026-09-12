import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_notifier.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_state.dart';

/// Follow/unfollow toggle for a venue page (ticket 10) — optimistic with
/// rollback on failure (see [FollowNotifier.toggle]), idempotent.
class FollowButton extends ConsumerWidget {
  const FollowButton({required this.venueId, super.key});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(followNotifierProvider(venueId));
    final notifier = ref.read(followNotifierProvider(venueId).notifier);

    return switch (state) {
      FollowLoading() => const SizedBox(
          width: 36,
          height: 36,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      FollowErrorState() => IconButton(
          onPressed: notifier.toggle,
          icon: const Icon(Icons.refresh, color: AppColors.onSurfaceVariant),
          tooltip: 'Réessayer',
        ),
      FollowFollowing() => _Pill(
          icon: Icons.notifications_active_rounded,
          label: 'Suivi',
          filled: true,
          onTap: notifier.toggle,
        ),
      FollowNotFollowing() => _Pill(
          icon: Icons.add_rounded,
          label: 'Suivre',
          filled: false,
          onTap: notifier.toggle,
        ),
    };
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : AppColors.surfaceContainerHighest,
      borderRadius: AppRadius.borderRadiusFull,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusFull,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: filled
                    ? AppColors.onPrimaryFixed
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: filled
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
