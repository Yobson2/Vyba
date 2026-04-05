import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/data_display/app_glass_card.dart';
import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';
import 'package:flutter_templates/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:flutter_templates/features/bookings/presentation/pages/booking_confirmation_page.dart';
import 'package:flutter_templates/features/bookings/presentation/providers/booking_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// 3-step booking flow: Date/Time -> Guests/Zone -> Summary/Confirm.
class BookTablePage extends ConsumerStatefulWidget {
  const BookTablePage({
    required this.venueId,
    required this.venueName,
    super.key,
  });

  final String venueId;
  final String venueName;

  @override
  ConsumerState<BookTablePage> createState() => _BookTablePageState();
}

class _BookTablePageState extends ConsumerState<BookTablePage> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Date & Time
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTimeSlot;

  // Step 2: Guests & Zone
  int _guestCount = 2;
  BookingZone _selectedZone = BookingZone.indoorLounge;

  bool _isLoading = false;

  final List<String> _timeSlots = [
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30',
  ];

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep = step);
  }

  Future<void> _confirmBooking() async {
    if (_selectedTimeSlot == null) return;
    setState(() => _isLoading = true);

    final useCase = ref.read(createBookingUseCaseProvider);
    final result = await useCase(
      CreateBookingParams(
        venueId: widget.venueId,
        date: _selectedDate,
        timeSlot: _selectedTimeSlot!,
        guestCount: _guestCount,
        zone: _selectedZone,
      ),
    );

    setState(() => _isLoading = false);

    result.fold(
      (Failure failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      (Booking booking) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => BookingConfirmationPage(booking: booking),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.venueName,
          style: GoogleFonts.epilogue(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildStep1DateTime(),
                _buildStep2GuestsZone(),
                _buildStep3Summary(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Text(
            'STEP ${_currentStep + 1} OF 3',
            style: GoogleFonts.epilogue(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          AppSpacing.verticalMd,
          Row(
            children: List.generate(3, (index) {
              final isActive = index <= _currentStep;
              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(
                    right: index < 2 ? AppSpacing.xs : 0,
                  ),
                  decoration: BoxDecoration(
                    gradient: isActive ? AppGradients.primaryButton : null,
                    color: isActive ? null : AppColors.surfaceContainerHigh,
                    borderRadius: AppRadius.borderRadiusFull,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Step 1: Date & Time ──────────────────────────────────────────

  Widget _buildStep1DateTime() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingHorizontalXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.verticalLg,
          Text(
            'Pick a Date',
            style: GoogleFonts.epilogue(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalLg,
          _AppDateScroller(
            selectedDate: _selectedDate,
            onDateSelected: (date) => setState(() => _selectedDate = date),
          ),
          AppSpacing.verticalXxl,
          Text(
            'Choose a Time',
            style: GoogleFonts.epilogue(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalLg,
          _AppTimeSlotGrid(
            slots: _timeSlots,
            selectedSlot: _selectedTimeSlot,
            onSlotSelected: (slot) => setState(() => _selectedTimeSlot = slot),
          ),
          AppSpacing.verticalXxl,
          AppGradientButton(
            onPressed: _selectedTimeSlot != null ? () => _goToStep(1) : null,
            label: 'Next',
          ),
          AppSpacing.verticalXl,
        ],
      ),
    );
  }

  // ── Step 2: Guests & Zone ────────────────────────────────────────

  Widget _buildStep2GuestsZone() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingHorizontalXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.verticalLg,
          Text(
            'Number of Guests',
            style: GoogleFonts.epilogue(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalLg,
          _AppStepperInput(
            value: _guestCount,
            min: 1,
            max: 20,
            onChanged: (val) => setState(() => _guestCount = val),
          ),
          AppSpacing.verticalXxl,
          Text(
            'Zone Preference',
            style: GoogleFonts.epilogue(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalLg,
          _buildZoneCard(
            BookingZone.indoorLounge,
            'Indoor Lounge',
            'Cozy ambiance with premium sound',
            Icons.weekend_outlined,
          ),
          AppSpacing.verticalMd,
          _buildZoneCard(
            BookingZone.outdoorTerrace,
            'Outdoor Terrace',
            'Open-air vibes under the Lagos sky',
            Icons.deck_outlined,
          ),
          AppSpacing.verticalMd,
          _buildZoneCard(
            BookingZone.vipBooth,
            'VIP Booth',
            'Exclusive private booth experience',
            Icons.star_outline_rounded,
          ),
          AppSpacing.verticalXxl,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goToStep(0),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.onSurface,
                    side: BorderSide(
                      color: AppColors.onSurface.withValues(alpha: 0.2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
              AppSpacing.horizontalMd,
              Expanded(
                flex: 2,
                child: AppGradientButton(
                  onPressed: () => _goToStep(2),
                  label: 'Next',
                ),
              ),
            ],
          ),
          AppSpacing.verticalXl,
        ],
      ),
    );
  }

  Widget _buildZoneCard(
    BookingZone zone,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = _selectedZone == zone;
    return GestureDetector(
      onTap: () => setState(() => _selectedZone = zone),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          gradient: isSelected ? AppGradients.primaryButton : null,
          color: isSelected ? null : AppColors.surfaceContainerHigh,
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.onPrimaryFixed
                  : AppColors.onSurfaceVariant,
              size: 28,
            ),
            AppSpacing.horizontalMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.onPrimaryFixed.withValues(alpha: 0.7)
                          : AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.onPrimaryFixed,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  // ── Step 3: Summary ──────────────────────────────────────────────

  Widget _buildStep3Summary() {
    final dateFormatted = DateFormat('EEE, dd MMM yyyy').format(_selectedDate);
    final zoneName = switch (_selectedZone) {
      BookingZone.indoorLounge => 'Indoor Lounge',
      BookingZone.outdoorTerrace => 'Outdoor Terrace',
      BookingZone.vipBooth => 'VIP Booth',
    };

    return SingleChildScrollView(
      padding: AppSpacing.paddingHorizontalXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.verticalLg,
          Text(
            'Reservation Summary',
            style: GoogleFonts.epilogue(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalXl,
          AppGlassCard(
            padding: AppSpacing.paddingXl,
            child: Column(
              children: [
                _summaryRow(Icons.location_on_outlined, 'Venue',
                    widget.venueName),
                AppSpacing.verticalLg,
                _summaryRow(
                    Icons.calendar_today_outlined, 'Date', dateFormatted),
                AppSpacing.verticalLg,
                _summaryRow(
                    Icons.access_time_outlined, 'Time', _selectedTimeSlot ?? ''),
                AppSpacing.verticalLg,
                _summaryRow(Icons.people_outline, 'Guests',
                    '$_guestCount ${_guestCount == 1 ? 'guest' : 'guests'}'),
                AppSpacing.verticalLg,
                _summaryRow(Icons.place_outlined, 'Zone', zoneName),
              ],
            ),
          ),
          AppSpacing.verticalXxl,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goToStep(1),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.onSurface,
                    side: BorderSide(
                      color: AppColors.onSurface.withValues(alpha: 0.2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
              AppSpacing.horizontalMd,
              Expanded(
                flex: 2,
                child: AppGradientButton(
                  onPressed: _isLoading ? null : _confirmBooking,
                  isLoading: _isLoading,
                  label: 'Confirm Reservation',
                ),
              ),
            ],
          ),
          AppSpacing.verticalXl,
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        AppSpacing.horizontalMd,
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────

/// Horizontal scrollable date picker showing next 14 days.
class _AppDateScroller extends StatelessWidget {
  const _AppDateScroller({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(
      14,
      (i) => DateTime(today.year, today.month, today.day + i + 1),
    );

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => AppSpacing.horizontalSm,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              decoration: BoxDecoration(
                gradient: isSelected ? AppGradients.primaryButton : null,
                color: isSelected ? null : AppColors.surfaceContainerHigh,
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date).toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: GoogleFonts.epilogue(
                      color: isSelected
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM').format(date).toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.onPrimaryFixed.withValues(alpha: 0.7)
                          : AppColors.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Grid of available time slots.
class _AppTimeSlotGrid extends StatelessWidget {
  const _AppTimeSlotGrid({
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  final List<String> slots;
  final String? selectedSlot;
  final ValueChanged<String> onSlotSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: slots.map((slot) {
        final isSelected = slot == selectedSlot;
        return GestureDetector(
          onTap: () => onSlotSelected(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              gradient: isSelected ? AppGradients.primaryButton : null,
              color: isSelected ? null : AppColors.surfaceContainerHigh,
              borderRadius: AppRadius.borderRadiusFull,
            ),
            child: Text(
              slot,
              style: TextStyle(
                color: isSelected
                    ? AppColors.onPrimaryFixed
                    : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Stepper input for guest count.
class _AppStepperInput extends StatelessWidget {
  const _AppStepperInput({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepperButton(
            icon: Icons.remove,
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          AppSpacing.horizontalXxl,
          Column(
            children: [
              Text(
                '$value',
                style: GoogleFonts.epilogue(
                  color: AppColors.onSurface,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value == 1 ? 'guest' : 'guests',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          AppSpacing.horizontalXxl,
          _stepperButton(
            icon: Icons.add,
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isEnabled ? AppColors.primary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

