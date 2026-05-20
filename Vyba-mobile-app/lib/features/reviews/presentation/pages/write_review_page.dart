import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/features/reviews/presentation/providers/review_providers.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-screen form for writing and submitting a venue review.
class WriteReviewPage extends ConsumerStatefulWidget {
  const WriteReviewPage({required this.venueId, super.key});

  /// The venue being reviewed.
  final String venueId;

  @override
  ConsumerState<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends ConsumerState<WriteReviewPage> {
  final _textController = TextEditingController();
  double _selectedRating = 0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _selectedRating > 0 && _textController.text.trim().isNotEmpty;

  Future<void> _onSubmit() async {
    if (!_canSubmit) return;
    await ref.read(reviewSubmitterProvider.notifier).submit(
          venueId: widget.venueId,
          rating: _selectedRating,
          text: _textController.text.trim(),
        );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitterState = ref.watch(reviewSubmitterProvider);
    final isLoading = submitterState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Write a Review',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingHorizontalXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.verticalXl,

              // --- Star rating selector ---
              Text(
                'How was your experience?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalLg,
              _InteractiveStarRating(
                rating: _selectedRating,
                onChanged: (rating) =>
                    setState(() => _selectedRating = rating),
              ),

              AppSpacing.verticalXxl,

              // --- Review text area ---
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tell others about your experience...',
                      hintStyle: TextStyle(
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: AppSpacing.paddingLg,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),

              AppSpacing.verticalXl,

              // --- Submit button ---
              AppGradientButton(
                onPressed: _canSubmit ? _onSubmit : null,
                label: 'Submit Review',
                isLoading: isLoading,
              ),

              AppSpacing.verticalXl,
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Interactive star rating
// ---------------------------------------------------------------------------

class _InteractiveStarRating extends StatelessWidget {
  const _InteractiveStarRating({
    required this.rating,
    required this.onChanged,
  });

  final double rating;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        final isFilled = starValue <= rating;
        return GestureDetector(
          onTap: () => onChanged(starValue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 44,
              color: isFilled ? AppColors.tertiary : AppColors.onSurfaceVariant,
            ),
          ),
        );
      }),
    );
  }
}
