import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/layout/app_tab_bar.dart';
import 'package:flutter_templates/features/owner_bookings/domain/entities/owner_booking.dart';
import 'package:flutter_templates/features/owner_bookings/presentation/providers/owner_booking_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManageBookingsPage extends ConsumerStatefulWidget {
  const ManageBookingsPage({super.key});

  @override
  ConsumerState<ManageBookingsPage> createState() => _ManageBookingsPageState();
}

class _ManageBookingsPageState extends ConsumerState<ManageBookingsPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(ownerBookingsProvider());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reservation\nManagement',
                style: GoogleFonts.epilogue(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              AppSpacing.verticalXl,
              AppTabBar(
                tabs: const ['Today', 'Upcoming', 'Past'],
                selectedIndex: _selectedTab,
                onTabSelected: (index) => setState(() => _selectedTab = index),
              ),
              AppSpacing.verticalXl,
              Expanded(
                child: bookingsAsync.when(
                  data: (List<OwnerBooking> bookings) {
                    final filtered = _filterBookings(bookings);
                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'No reservations found',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => AppSpacing.verticalMd,
                      itemBuilder: (context, index) =>
                          _BookingCard(booking: filtered[index]),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      'Failed to load bookings',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<OwnerBooking> _filterBookings(List<OwnerBooking> bookings) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (_selectedTab) {
      case 0: // Today
        return bookings
            .where((b) =>
                DateTime(b.date.year, b.date.month, b.date.day) == today)
            .toList();
      case 1: // Upcoming
        return bookings
            .where((b) =>
                DateTime(b.date.year, b.date.month, b.date.day).isAfter(today))
            .toList();
      case 2: // Past
        return bookings
            .where((b) =>
                DateTime(b.date.year, b.date.month, b.date.day)
                    .isBefore(today))
            .toList();
      default:
        return bookings;
    }
  }
}

class _BookingCard extends ConsumerWidget {
  const _BookingCard({required this.booking});

  final OwnerBooking booking;

  Color get _statusColor {
    switch (booking.status) {
      case OwnerBookingStatus.pending:
        return AppColors.tertiary;
      case OwnerBookingStatus.confirmed:
        return AppColors.success;
      case OwnerBookingStatus.declined:
        return AppColors.error;
      case OwnerBookingStatus.completed:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left border color coded by status
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.md),
                  bottomLeft: Radius.circular(AppRadius.md),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Guest avatar + name + time
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              AppColors.primaryDim.withValues(alpha: 0.3),
                          backgroundImage:
                              NetworkImage(booking.guestAvatarUrl),
                          onBackgroundImageError: (_, __) {},
                          child: Text(
                            booking.guestName[0],
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        AppSpacing.horizontalMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.guestName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              AppSpacing.verticalXs,
                              Text(
                                '${DateFormat('MMM d').format(booking.date)} at ${booking.timeSlot}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor.withValues(alpha: 0.15),
                            borderRadius: AppRadius.borderRadiusFull,
                          ),
                          child: Text(
                            booking.status.name[0].toUpperCase() +
                                booking.status.name.substring(1),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: _statusColor,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalMd,

                    // Stats row
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.people_rounded,
                          label: '${booking.guestCount} Guests',
                        ),
                        AppSpacing.horizontalSm,
                        _InfoChip(
                          icon: Icons.place_rounded,
                          label: booking.areaLabel,
                        ),
                        AppSpacing.horizontalSm,
                        _InfoChip(
                          icon: Icons.payments_rounded,
                          label: currencyFormat.format(booking.depositAmount),
                        ),
                      ],
                    ),

                    // Action buttons for pending bookings
                    if (booking.status == OwnerBookingStatus.pending) ...[
                      AppSpacing.verticalMd,
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              label: 'Decline',
                              color: AppColors.error,
                              onTap: () {
                                ref
                                    .read(
                                      ownerBookingActionsProvider.notifier,
                                    )
                                    .decline(booking.id);
                              },
                            ),
                          ),
                          AppSpacing.horizontalSm,
                          Expanded(
                            child: _ActionButton(
                              label: 'Confirm',
                              color: AppColors.success,
                              filled: true,
                              onTap: () {
                                ref
                                    .read(
                                      ownerBookingActionsProvider.notifier,
                                    )
                                    .confirm(booking.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          border: filled ? null : Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: AppRadius.borderRadiusSm,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: filled ? Colors.black : color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
