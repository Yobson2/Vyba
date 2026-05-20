import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/activity_item.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/dashboard_stats.dart';

abstract class OwnerDashboardDataSource {
  Future<DashboardStats> getDashboardStats();
  Future<List<ActivityItem>> getRecentActivity();
  Future<List<Booking>> getUpcomingBookings();
}

class MockOwnerDashboardDataSource implements OwnerDashboardDataSource {
  @override
  Future<DashboardStats> getDashboardStats() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const DashboardStats(
      todayBookings: 24,
      activePromos: 3,
      weekViews: 1200,
      bookingsTrend: 12,
    );
  }

  @override
  Future<List<ActivityItem>> getRecentActivity() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return [
      ActivityItem(
        id: 'act-1',
        type: ActivityType.booking,
        message: 'Amara Obi confirmed reservation for 6 guests',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ActivityItem(
        id: 'act-2',
        type: ActivityType.review,
        message: 'New 5-star review from Chidi Eze on The Vibe Lounge',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ActivityItem(
        id: 'act-3',
        type: ActivityType.system,
        message: 'Your Happy Hour promo reaches 500+ views',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  @override
  Future<List<Booking>> getUpcomingBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return [
      Booking(
        id: 'obk-001',
        venueId: '1',
        venueName: 'The Vibe Lounge',
        venueImage: '',
        date: DateTime.now(),
        timeSlot: '21:00',
        guestCount: 4,
        zone: BookingZone.vipBooth,
        status: BookingStatus.confirmed,
        bookingReference: 'LP-VIB-4829',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Booking(
        id: 'obk-002',
        venueId: '1',
        venueName: 'The Vibe Lounge',
        venueImage: '',
        date: DateTime.now(),
        timeSlot: '22:00',
        guestCount: 8,
        zone: BookingZone.outdoorTerrace,
        status: BookingStatus.confirmed,
        bookingReference: 'LP-VIB-4830',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      Booking(
        id: 'obk-003',
        venueId: '1',
        venueName: 'The Vibe Lounge',
        venueImage: '',
        date: DateTime.now(),
        timeSlot: '23:00',
        guestCount: 2,
        zone: BookingZone.indoorLounge,
        status: BookingStatus.pending,
        bookingReference: 'LP-VIB-4831',
        createdAt: DateTime.now(),
      ),
    ];
  }
}
