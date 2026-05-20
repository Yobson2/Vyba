import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/states/app_empty_state.dart';
import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';
import 'package:flutter_templates/features/bookings/presentation/providers/booking_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// My bookings list with Upcoming / Past / Cancelled tabs.
class MyBookingsPage extends ConsumerStatefulWidget {
  const MyBookingsPage({super.key});

  @override
  ConsumerState<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends ConsumerState<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'My Bookings',
          style: GoogleFonts.epilogue(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          dividerColor: Colors.transparent,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BookingsList(
            statusFilter: null,
            filterFn: (b) =>
                b.status == BookingStatus.confirmed ||
                b.status == BookingStatus.pending,
            emptyIcon: Icons.calendar_today_outlined,
            emptyTitle: 'No upcoming bookings',
            emptySubtitle: 'Book a table to get started',
          ),
          _BookingsList(
            statusFilter: BookingStatus.completed,
            filterFn: (b) => b.status == BookingStatus.completed,
            emptyIcon: Icons.history_outlined,
            emptyTitle: 'No past bookings',
            emptySubtitle: 'Your completed bookings will appear here',
          ),
          _BookingsList(
            statusFilter: BookingStatus.cancelled,
            filterFn: (b) => b.status == BookingStatus.cancelled,
            emptyIcon: Icons.cancel_outlined,
            emptyTitle: 'No cancelled bookings',
            emptySubtitle: 'Cancelled bookings will appear here',
          ),
        ],
      ),
    );
  }
}

class _BookingsList extends ConsumerStatefulWidget {
  const _BookingsList({
    required this.statusFilter,
    required this.filterFn,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final BookingStatus? statusFilter;
  final bool Function(Booking) filterFn;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  ConsumerState<_BookingsList> createState() => _BookingsListState();
}

class _BookingsListState extends ConsumerState<_BookingsList> {
  List<Booking>? _bookings;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final useCase = ref.read(getMyBookingsUseCaseProvider);
    final result = await useCase(null);

    if (!mounted) return;
    result.fold(
      (Failure failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (List<Booking> allBookings) => setState(() {
        _bookings = allBookings.where(widget.filterFn).toList();
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: AppColors.error)),
            AppSpacing.verticalMd,
            TextButton(
              onPressed: _loadBookings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final bookings = _bookings ?? [];
    if (bookings.isEmpty) {
      return AppEmptyState(
        icon: widget.emptyIcon,
        title: widget.emptyTitle,
        subtitle: widget.emptySubtitle,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => AppSpacing.verticalMd,
      itemBuilder: (context, index) => _BookingCard(booking: bookings[index]),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('EEE, dd MMM').format(booking.date);
    final statusLabel = switch (booking.status) {
      BookingStatus.confirmed => 'Confirmed',
      BookingStatus.pending => 'Pending',
      BookingStatus.cancelled => 'Cancelled',
      BookingStatus.completed => 'Completed',
    };
    final statusColor = switch (booking.status) {
      BookingStatus.confirmed => AppColors.secondary,
      BookingStatus.pending => AppColors.tertiary,
      BookingStatus.cancelled => AppColors.error,
      BookingStatus.completed => AppColors.onSurfaceVariant,
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Row(
        children: [
          // Venue image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.md),
              bottomLeft: Radius.circular(AppRadius.md),
            ),
            child: SizedBox(
              width: 100,
              height: 110,
              child: Image.network(
                booking.venueImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceContainerHighest,
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          // Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          booking.venueName,
                          style: GoogleFonts.epilogue(
                            color: AppColors.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppSpacing.horizontalSm,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: AppRadius.borderRadiusFull,
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalSm,
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                      AppSpacing.horizontalXs,
                      Text(
                        '$dateFormatted at ${booking.timeSlot}',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalXs,
                  Row(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                      AppSpacing.horizontalXs,
                      Text(
                        '${booking.guestCount} ${booking.guestCount == 1 ? 'guest' : 'guests'}',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
