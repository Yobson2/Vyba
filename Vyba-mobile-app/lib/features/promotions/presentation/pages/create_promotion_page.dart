import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promotion.dart';
import 'package:flutter_templates/features/promotions/presentation/providers/promotion_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CreatePromotionPage extends ConsumerStatefulWidget {
  const CreatePromotionPage({super.key});

  @override
  ConsumerState<CreatePromotionPage> createState() =>
      _CreatePromotionPageState();
}

class _CreatePromotionPageState extends ConsumerState<CreatePromotionPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  PromoType _selectedType = PromoType.happyHour;
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 17, minute: 0);
  bool _isPremiumBoosted = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surfaceContainerHigh,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surfaceContainerHigh,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _handleCreate() async {
    if (_titleController.text.isEmpty) return;
    final startDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final success =
        await ref.read(createPromotionNotifierProvider.notifier).create(
              title: _titleController.text,
              description: _descriptionController.text,
              promoType: _selectedType,
              startDate: startDateTime,
              endDate: startDateTime.add(const Duration(hours: 4)),
              venueId: '1',
              isPremiumBoosted: _isPremiumBoosted,
            );
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createPromotionNotifierProvider);
    final isLoading = createState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Create Promotion',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title input
            _SectionLabel(label: 'Promotion Title'),
            AppSpacing.verticalSm,
            _EditorialTextField(
              controller: _titleController,
              hintText: 'e.g. Friday Happy Hour',
            ),

            AppSpacing.verticalXl,

            // Image uploader placeholder
            _SectionLabel(label: 'Promo Visual'),
            AppSpacing.verticalSm,
            _ImageUploadPlaceholder(),

            AppSpacing.verticalXl,

            // Promo type selector
            _SectionLabel(label: 'Promotion Type'),
            AppSpacing.verticalSm,
            Row(
              children: PromoType.values.map((type) {
                final isSelected = type == _selectedType;
                final label = switch (type) {
                  PromoType.happyHour => 'Happy Hour',
                  PromoType.event => 'Event',
                  PromoType.discount => 'Discount',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                        borderRadius: AppRadius.borderRadiusFull,
                      ),
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: isSelected
                                  ? AppColors.onPrimaryFixed
                                  : AppColors.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            AppSpacing.verticalXl,

            // Description
            _SectionLabel(label: 'Description'),
            AppSpacing.verticalSm,
            _EditorialTextField(
              controller: _descriptionController,
              hintText: 'Describe your promotion...',
              maxLines: 4,
            ),

            AppSpacing.verticalXl,

            // Date and time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(label: 'Start Date'),
                      AppSpacing.verticalSm,
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHighest,
                            borderRadius: AppRadius.borderRadiusSm,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: AppColors.onSurfaceVariant,
                              ),
                              AppSpacing.horizontalSm,
                              Text(
                                DateFormat('MMM d, yyyy').format(_startDate),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontalMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(label: 'Start Time'),
                      AppSpacing.verticalSm,
                      GestureDetector(
                        onTap: _selectTime,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHighest,
                            borderRadius: AppRadius.borderRadiusSm,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: AppColors.onSurfaceVariant,
                              ),
                              AppSpacing.horizontalSm,
                              Text(
                                _startTime.format(context),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            AppSpacing.verticalXl,

            // Premium boost toggle
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium Boost',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        AppSpacing.verticalXs,
                        Text(
                          'Get featured placement and 3x more visibility',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isPremiumBoosted,
                    onChanged: (value) =>
                        setState(() => _isPremiumBoosted = value),
                    activeColor: AppColors.tertiary,
                    activeTrackColor:
                        AppColors.tertiary.withValues(alpha: 0.3),
                    inactiveThumbColor: AppColors.onSurfaceVariant,
                    inactiveTrackColor: AppColors.surfaceContainerHighest,
                  ),
                ],
              ),
            ),

            AppSpacing.verticalXl,

            // Preview section
            _SectionLabel(label: 'Preview'),
            AppSpacing.verticalSm,
            _PromoPreviewCard(
              title: _titleController.text.isEmpty
                  ? 'Your Promotion Title'
                  : _titleController.text,
              type: _selectedType,
              isPremium: _isPremiumBoosted,
              date: _startDate,
            ),

            AppSpacing.verticalXl,

            // Create button
            AppGradientButton(
              onPressed: isLoading ? null : _handleCreate,
              label: 'Create Promotion',
              isLoading: isLoading,
              gradient: AppGradients.primaryButton,
            ),

            AppSpacing.verticalXl,
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
            letterSpacing: 1.0,
          ),
    );
  }
}

class _EditorialTextField extends StatelessWidget {
  const _EditorialTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
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

class _ImageUploadPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: AppRadius.borderRadiusMd,
          border: Border.all(
            color: AppColors.outlineVariant,
            style: BorderStyle.solid,
          ),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: AppColors.outlineVariant,
            borderRadius: AppRadius.md,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  size: 40,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                AppSpacing.verticalSm,
                Text(
                  'Tap to upload image',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
  });

  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    const dashWidth = 8.0;
    const dashSpace = 4.0;
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, end.clamp(0, metric.length)),
          paint,
        );
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PromoPreviewCard extends StatelessWidget {
  const _PromoPreviewCard({
    required this.title,
    required this.type,
    required this.isPremium,
    required this.date,
  });

  final String title;
  final PromoType type;
  final bool isPremium;
  final DateTime date;

  String get _typeLabel => switch (type) {
        PromoType.happyHour => 'Happy Hour',
        PromoType.event => 'Event',
        PromoType.discount => 'Discount',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryButton,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: AppRadius.borderRadiusFull,
                ),
                child: Text(
                  _typeLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (isPremium) ...[
                AppSpacing.horizontalSm,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.3),
                    borderRadius: AppRadius.borderRadiusFull,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 12,
                        color: AppColors.tertiary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'BOOSTED',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.tertiary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          AppSpacing.verticalMd,
          Text(
            title,
            style: GoogleFonts.epilogue(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          AppSpacing.verticalXs,
          Text(
            DateFormat('EEE, MMM d').format(date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}
