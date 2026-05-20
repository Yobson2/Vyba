import 'package:flutter/material.dart';

/// Small icon indicating an item's sync status.
///
/// Shows a cloud-upload icon when the item hasn't been synced yet.
/// Returns an empty [SizedBox] when synced.
///
/// Usage:
/// ```dart
/// ListTile(
///   trailing: SyncStatusIcon(isSynced: note.isSynced),
/// )
/// ```
class SyncStatusIcon extends StatelessWidget {
  /// Creates a [SyncStatusIcon].
  const SyncStatusIcon({
    super.key,
    required this.isSynced,
    this.size = 18,
  });

  /// Whether the item has been synced to the server.
  final bool isSynced;

  /// Icon size. Defaults to 18.
  final double size;

  @override
  Widget build(BuildContext context) {
    if (isSynced) return const SizedBox.shrink();

    return Icon(
      Icons.cloud_upload_outlined,
      size: size,
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
    );
  }
}
