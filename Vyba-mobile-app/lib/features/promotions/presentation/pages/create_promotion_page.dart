import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/features/promotions/presentation/providers/create_promo_notifier.dart';
import 'package:google_fonts/google_fonts.dart';

/// Minimal, fast create-promo form (ticket 09) — title + description only,
/// no photo (ticket 14), target under 10 seconds start to finish.
class CreatePromotionPage extends ConsumerStatefulWidget {
  const CreatePromotionPage({super.key});

  @override
  ConsumerState<CreatePromotionPage> createState() =>
      _CreatePromotionPageState();
}

class _CreatePromotionPageState extends ConsumerState<CreatePromotionPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handlePublish() async {
    if (_titleController.text.trim().isEmpty) return;
    final success =
        await ref.read(createPromoNotifierProvider.notifier).submit(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
            );
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPromoNotifierProvider);
    final canPublish = _titleController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Nouvelle promo',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel(label: 'Titre'),
            AppSpacing.verticalSm,
            _PromoTextField(
              controller: _titleController,
              hintText: 'Ex. Happy hour -50% jusqu’à 23h',
              onChanged: (_) => setState(() {}),
            ),
            AppSpacing.verticalLg,
            const _SectionLabel(label: 'Description'),
            AppSpacing.verticalSm,
            _PromoTextField(
              controller: _descriptionController,
              hintText: 'Sur tous les cocktails, ce soir seulement.',
              maxLines: 4,
            ),
            if (state.errorMessage != null) ...[
              AppSpacing.verticalMd,
              Text(
                state.errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),
            ],
            AppSpacing.verticalXl,
            AppGradientButton(
              onPressed:
                  (canPublish && !state.submitting) ? _handlePublish : null,
              label: 'Publier',
              isLoading: state.submitting,
              gradient: AppGradients.primaryButton,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1,
          ),
    );
  }
}

class _PromoTextField extends StatelessWidget {
  const _PromoTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurface,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: AppRadius.borderRadiusSm,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
          borderRadius: AppRadius.borderRadiusSm,
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }
}
