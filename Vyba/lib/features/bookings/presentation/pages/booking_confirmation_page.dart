import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/data_display/app_glass_card.dart';
import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Booking confirmation success screen with QR code placeholder.
class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({
    required this.booking,
    super.key,
  });

  final Booking booking;

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _zoneName => switch (widget.booking.zone) {
        BookingZone.indoorLounge => 'Indoor Lounge',
        BookingZone.outdoorTerrace => 'Outdoor Terrace',
        BookingZone.vipBooth => 'VIP Booth',
      };

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final dateFormatted = DateFormat('EEE, dd MMM yyyy').format(booking.date);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalXl,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              // Pulsing checkmark
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primaryButton,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.4),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.onPrimaryFixed,
                    size: 44,
                  ),
                ),
              ),
              AppSpacing.verticalXl,
              Text(
                'Confirmed!',
                style: GoogleFonts.epilogue(
                  color: AppColors.secondary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppSpacing.verticalSm,
              Text(
                'Your reservation is all set',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              AppSpacing.verticalXxl,
              // Venue preview image
              ClipRRect(
                borderRadius: AppRadius.borderRadiusMd,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    booking.venueImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColors.onSurfaceVariant,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.verticalXl,
              // Reservation summary card
              AppGlassCard(
                padding: AppSpacing.paddingXl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.venueName,
                      style: GoogleFonts.epilogue(
                        color: AppColors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (booking.bookingReference != null) ...[
                      AppSpacing.verticalXs,
                      Text(
                        'Ref: ${booking.bookingReference}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                    AppSpacing.verticalLg,
                    const Divider(
                      color: AppColors.surfaceContainerHighest,
                      height: 1,
                    ),
                    AppSpacing.verticalLg,
                    _detailRow(
                      Icons.calendar_today_outlined,
                      'Date',
                      dateFormatted,
                    ),
                    AppSpacing.verticalMd,
                    _detailRow(
                      Icons.access_time_outlined,
                      'Time',
                      booking.timeSlot,
                    ),
                    AppSpacing.verticalMd,
                    _detailRow(
                      Icons.people_outline,
                      'Guests',
                      '${booking.guestCount} ${booking.guestCount == 1 ? 'guest' : 'guests'}',
                    ),
                    AppSpacing.verticalMd,
                    _detailRow(Icons.place_outlined, 'Zone', _zoneName),
                  ],
                ),
              ),
              AppSpacing.verticalXl,
              // QR code placeholder
              AppGlassCard(
                padding: AppSpacing.paddingXl,
                child: Column(
                  children: [
                    Text(
                      'Your QR Code',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    AppSpacing.verticalLg,
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.onSurface,
                        borderRadius: AppRadius.borderRadiusSm,
                      ),
                      child: CustomPaint(
                        painter: _QrPlaceholderPainter(),
                      ),
                    ),
                    AppSpacing.verticalMd,
                    Text(
                      'Show this at the entrance',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalXxl,
              // Add to Calendar button
              OutlinedButton.icon(
                onPressed: () {
                  // Calendar integration placeholder
                },
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('Add to Calendar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                ),
              ),
              AppSpacing.verticalMd,
              // Done button
              AppGradientButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                label: 'Done',
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
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

/// Paints a grid pattern to simulate a QR code placeholder.
class _QrPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.background;
    const cellSize = 10.0;
    final cols = (size.width / cellSize).floor();
    final rows = (size.height / cellSize).floor();

    // Simple deterministic grid pattern
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final fill = ((r * 7 + c * 13) % 3 == 0) ||
            (r < 3 && c < 3) ||
            (r < 3 && c >= cols - 3) ||
            (r >= rows - 3 && c < 3);
        if (fill) {
          canvas.drawRect(
            Rect.fromLTWH(
              c * cellSize,
              r * cellSize,
              cellSize - 1,
              cellSize - 1,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
