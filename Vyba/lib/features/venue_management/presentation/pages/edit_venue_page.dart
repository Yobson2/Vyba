import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/features/venue_management/domain/entities/venue_profile.dart';
import 'package:flutter_templates/features/venue_management/presentation/providers/venue_management_providers.dart';
import 'package:google_fonts/google_fonts.dart';

class EditVenuePage extends ConsumerStatefulWidget {
  const EditVenuePage({super.key, required this.venue});

  final VenueProfile venue;

  @override
  ConsumerState<EditVenuePage> createState() => _EditVenuePageState();
}

class _EditVenuePageState extends ConsumerState<EditVenuePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late int _priceLevel;
  late List<String> _selectedAmenities;

  static const _allAmenities = [
    'VIP Booths',
    'Outdoor Terrace',
    'Live DJ',
    'Hookah',
    'Parking',
    'Bottle Service',
    'Rooftop Views',
    'Live Music',
    'Cocktail Bar',
    'Private Events',
    'WiFi',
    'Karaoke',
    'Dance Floor',
    'Pool',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue.name);
    _descriptionController =
        TextEditingController(text: widget.venue.description);
    _addressController = TextEditingController(text: widget.venue.address);
    _phoneController = TextEditingController(text: widget.venue.phone);
    _priceLevel = widget.venue.priceLevel;
    _selectedAmenities = List<String>.from(widget.venue.amenities);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final updated = widget.venue.copyWith(
      name: _nameController.text,
      description: _descriptionController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      priceLevel: _priceLevel,
      amenities: _selectedAmenities,
    );
    final success =
        await ref.read(updateVenueNotifierProvider.notifier).saveVenue(updated);
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateVenueNotifierProvider);
    final isLoading = updateState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Venue',
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
            // Venue name
            const _SectionLabel(label: 'Venue Name'),
            AppSpacing.verticalSm,
            _EditorialField(
              controller: _nameController,
              hintText: 'Venue name',
            ),

            AppSpacing.verticalXl,

            // Description
            const _SectionLabel(label: 'Description'),
            AppSpacing.verticalSm,
            _EditorialField(
              controller: _descriptionController,
              hintText: 'Describe your venue...',
              maxLines: 4,
            ),

            AppSpacing.verticalXl,

            // Address
            const _SectionLabel(label: 'Address'),
            AppSpacing.verticalSm,
            _EditorialField(
              controller: _addressController,
              hintText: 'Venue address',
            ),

            AppSpacing.verticalXl,

            // Phone
            const _SectionLabel(label: 'Phone'),
            AppSpacing.verticalSm,
            _EditorialField(
              controller: _phoneController,
              hintText: '+234 ...',
            ),

            AppSpacing.verticalXl,

            // Opening hours
            const _SectionLabel(label: 'Opening Hours'),
            AppSpacing.verticalSm,
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Column(
                children: widget.venue.openingHours.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                        Text(
                          entry.value,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            AppSpacing.verticalXl,

            // Amenities
            const _SectionLabel(label: 'Amenities'),
            AppSpacing.verticalSm,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _allAmenities.map((amenity) {
                final isSelected = _selectedAmenities.contains(amenity);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedAmenities.remove(amenity);
                      } else {
                        _selectedAmenities.add(amenity);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.surfaceContainerHigh,
                      borderRadius: AppRadius.borderRadiusFull,
                      border: isSelected
                          ? Border.all(
                              color: AppColors.primary.withValues(alpha: 0.5),
                            )
                          : null,
                    ),
                    child: Text(
                      amenity,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                    ),
                  ),
                );
              }).toList(),
            ),

            AppSpacing.verticalXl,

            // Gallery placeholder
            const _SectionLabel(label: 'Gallery'),
            AppSpacing.verticalSm,
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.venue.images.length + 1,
                separatorBuilder: (_, __) => AppSpacing.horizontalSm,
                itemBuilder: (context, index) {
                  if (index == widget.venue.images.length) {
                    return Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: AppRadius.borderRadiusSm,
                        border: Border.all(
                          color: AppColors.outlineVariant,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          color: AppColors.onSurfaceVariant,
                          size: 32,
                        ),
                      ),
                    );
                  }
                  return ClipRRect(
                    borderRadius: AppRadius.borderRadiusSm,
                    child: Image.network(
                      widget.venue.images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 100,
                        color: AppColors.surfaceContainerHighest,
                        child: const Icon(
                          Icons.broken_image_rounded,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            AppSpacing.verticalXl,

            // Price level
            const _SectionLabel(label: 'Price Level'),
            AppSpacing.verticalSm,
            Row(
              children: List.generate(4, (index) {
                final level = index + 1;
                final isSelected = level <= _priceLevel;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => setState(() => _priceLevel = level),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.tertiary.withValues(alpha: 0.2)
                            : AppColors.surfaceContainerHigh,
                        borderRadius: AppRadius.borderRadiusFull,
                        border: isSelected
                            ? Border.all(
                                color:
                                    AppColors.tertiary.withValues(alpha: 0.5),
                              )
                            : null,
                      ),
                      child: Text(
                        '\u20A6' * level,
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: isSelected
                                      ? AppColors.tertiary
                                      : AppColors.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            AppSpacing.verticalXxl,

            // Save button
            AppGradientButton(
              onPressed: isLoading ? null : _handleSave,
              label: 'Save Changes',
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

class _EditorialField extends StatelessWidget {
  const _EditorialField({
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
