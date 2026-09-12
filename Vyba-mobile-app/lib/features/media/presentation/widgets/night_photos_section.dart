import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/media/presentation/providers/add_photo_notifier.dart';
import 'package:flutter_templates/features/media/presentation/providers/add_photo_state.dart';
import 'package:flutter_templates/features/media/presentation/providers/venue_night_photos_provider.dart';
import 'package:image_picker/image_picker.dart';

/// "Ajouter une photo" (ticket 14 / spec 06): a client's photo shows here
/// immediately; the copy sets the expectation that it may or may not be
/// featured in the main feed (only a Vyba team promotion does that).
class NightPhotosSection extends ConsumerWidget {
  const NightPhotosSection({required this.venueId, super.key});

  final String venueId;

  Future<void> _pickAndUpload(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return;

    await ref
        .read(addPhotoNotifierProvider(venueId).notifier)
        .upload(picked.path);

    if (!context.mounted) return;
    final state = ref.read(addPhotoNotifierProvider(venueId));
    switch (state) {
      case AddPhotoSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo ajoutée pour ce soir !')),
        );
      case AddPhotoError(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      case AddPhotoIdle():
      case AddPhotoUploading():
        break;
    }
    ref.read(addPhotoNotifierProvider(venueId).notifier).reset();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addState = ref.watch(addPhotoNotifierProvider(venueId));
    final photosAsync = ref.watch(venueNightPhotosProvider(venueId));
    final isUploading = addState is AddPhotoUploading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Photos de ce soir',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton.icon(
              onPressed:
                  isUploading ? null : () => _pickAndUpload(context, ref),
              icon: isUploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_a_photo_outlined, size: 18),
              label: const Text('Ajouter une photo'),
            ),
          ],
        ),
        AppSpacing.verticalXs,
        Text(
          "Visible ici tout de suite. L'équipe Vyba peut la mettre en avant dans le fil, sans garantie.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        AppSpacing.verticalSm,
        photosAsync.when(
          loading: () => const SizedBox(
            height: 88,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (error, stackTrace) => const SizedBox.shrink(),
          data: (photos) {
            if (photos.isEmpty) return const SizedBox.shrink();
            return SizedBox(
              height: 88,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return ClipRRect(
                    borderRadius: AppRadius.borderRadiusSm,
                    child: Image.network(
                      photo.thumbnailUrl,
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
