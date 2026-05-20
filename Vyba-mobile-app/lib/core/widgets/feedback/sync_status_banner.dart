import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/sync/sync_providers.dart';
import 'package:flutter_templates/core/sync/sync_status.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Banner that displays the current sync status.
///
/// Shows contextual messages for offline, syncing, error, and synced states.
/// Place below the app bar in a [Column] or as part of a [Scaffold] body.
class SyncStatusBanner extends ConsumerWidget {
  /// Creates a [SyncStatusBanner].
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(syncStatusProvider);

    return statusAsync.when(
      data: (status) => switch (status) {
        SyncOffline(:final pendingCount) => _Banner(
            icon: Icons.cloud_off,
            message: 'Offline. $pendingCount change${pendingCount == 1 ? '' : 's'} pending.',
            color: Theme.of(context).colorScheme.error,
          ),
        SyncSyncing(:final total, :final completed) => _Banner(
            icon: Icons.cloud_sync,
            message: 'Syncing... ($completed/$total)',
            color: Theme.of(context).colorScheme.primary,
          ),
        SyncError(:final message) => _Banner(
            icon: Icons.cloud_off,
            message: 'Sync failed: $message',
            color: Theme.of(context).colorScheme.error,
            action: TextButton(
              onPressed: () => ref.read(syncEngineProvider).processQueue(),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ),
        SyncSynced() || SyncIdle() => const SizedBox.shrink(),
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.message,
    required this.color,
    this.action,
  });

  final IconData icon;
  final String message;
  final Color color;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final foreground = ThemeData.estimateBrightnessForColor(color) ==
            Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.lg,
      ),
      color: color,
      child: Row(
        children: [
          Icon(icon, size: 16, color: foreground),
          AppSpacing.horizontalSm,
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
