import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/features/owner_broadcast/presentation/providers/owner_broadcast_notifier.dart';

const _messageMaxLength = 140;

/// "Prévenir ceux qui viennent ce soir" (ticket 17 / spec 08) — one short
/// message to tonight's opted-in "going" crowd, once per venue per night.
class OwnerBroadcastAction extends ConsumerWidget {
  const OwnerBroadcastAction({super.key});

  Future<void> _openComposer(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _ComposerDialog(controller: controller),
    );
    controller.dispose();
    if ((sent ?? false) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message envoyé.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ownerBroadcastNotifierProvider);
    final alreadySent = state.sent || state.alreadySentTonight;

    return OutlinedButton.icon(
      onPressed: alreadySent ? null : () => _openComposer(context, ref),
      icon: Icon(
          alreadySent ? Icons.check_circle_outline : Icons.campaign_outlined),
      label: Text(
        alreadySent
            ? 'Déjà envoyé ce soir'
            : 'Prévenir ceux qui viennent ce soir',
      ),
    );
  }
}

class _ComposerDialog extends ConsumerStatefulWidget {
  const _ComposerDialog({required this.controller});

  final TextEditingController controller;

  @override
  ConsumerState<_ComposerDialog> createState() => _ComposerDialogState();
}

class _ComposerDialogState extends ConsumerState<_ComposerDialog> {
  Future<void> _send() async {
    final message = widget.controller.text.trim();
    if (message.isEmpty) return;
    await ref.read(ownerBroadcastNotifierProvider.notifier).send(message);
    if (!mounted) return;
    final state = ref.read(ownerBroadcastNotifierProvider);
    if (state.sent) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownerBroadcastNotifierProvider);

    return AlertDialog(
      title: const Text('Prévenir ceux qui viennent ce soir'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            maxLength: _messageMaxLength,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Happy hour prolongée jusqu'à minuit !",
            ),
          ),
          if (state.errorMessage != null)
            Text(
              state.errorMessage!,
              style: const TextStyle(color: AppColors.error),
            ),
          if (state.alreadySentTonight)
            const Text(
              'Déjà envoyé ce soir.',
              style: TextStyle(color: AppColors.error),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: state.submitting ? null : _send,
          child: state.submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Envoyer'),
        ),
      ],
    );
  }
}
