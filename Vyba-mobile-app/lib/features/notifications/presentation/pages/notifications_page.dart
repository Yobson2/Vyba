import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/data_display/app_glass_card.dart';
import 'package:flutter_templates/features/notifications/domain/entities/app_notification.dart';
import 'package:flutter_templates/features/notifications/presentation/providers/notification_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Page displaying all notifications grouped by date (Today / Yesterday / Earlier).
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.glassBg,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.epilogue(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x800F172A),
                Color(0x000F172A),
              ],
            ),
          ),
        ),
      ),
      body: notificationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (Object error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (List<AppNotification> notifications) =>
            _NotificationsList(notifications: notifications),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

// ---------------------------------------------------------------------------
// Grouped notification list
// ---------------------------------------------------------------------------

class _NotificationsList extends ConsumerWidget {
  const _NotificationsList({required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              size: 64,
              color: AppColors.onSurfaceVariant,
            ),
            AppSpacing.verticalLg,
            Text(
              'No notifications yet',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    final groups = _groupByDate(notifications);

    return ListView.builder(
      padding: AppSpacing.paddingLg,
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) AppSpacing.verticalXl,
            // Section header
            Row(
              children: [
                Text(
                  group.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                ),
                AppSpacing.horizontalMd,
                const Expanded(
                  child: Divider(color: AppColors.outlineVariant, thickness: 0.5),
                ),
              ],
            ),
            AppSpacing.verticalMd,
            // Notification cards
            ...group.notifications.map(
              (notification) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _NotificationCard(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      ref
                          .read(notificationMarkerProvider.notifier)
                          .markAsRead(notification.id);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<_DateGroup> _groupByDate(List<AppNotification> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayList = <AppNotification>[];
    final yesterdayList = <AppNotification>[];
    final earlierList = <AppNotification>[];

    for (final n in items) {
      final date = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      if (date == today) {
        todayList.add(n);
      } else if (date == yesterday) {
        yesterdayList.add(n);
      } else {
        earlierList.add(n);
      }
    }

    return [
      if (todayList.isNotEmpty) _DateGroup('Today', todayList),
      if (yesterdayList.isNotEmpty) _DateGroup('Yesterday', yesterdayList),
      if (earlierList.isNotEmpty) _DateGroup('Earlier', earlierList),
    ];
  }
}

class _DateGroup {
  const _DateGroup(this.label, this.notifications);
  final String label;
  final List<AppNotification> notifications;
}

// ---------------------------------------------------------------------------
// Single notification card
// ---------------------------------------------------------------------------

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: notification.isRead ? 0.7 : 1.0,
        child: AppGlassCard(
          borderRadius: AppRadius.borderRadiusMd,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type icon
              _TypeIcon(type: notification.type),
              AppSpacing.horizontalMd,

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with unread dot
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.epilogue(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Timestamp
                    Text(
                      timeFormat.format(notification.createdAt).toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.1,
                      ),
                    ),

                    AppSpacing.verticalSm,

                    // Body — highlight venue names in primary color
                    _HighlightedBody(text: notification.body),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Type-specific icon in colored circle
// ---------------------------------------------------------------------------

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final NotificationType type;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (type) {
      NotificationType.bookingConfirmed => (Icons.check_circle, AppColors.secondary),
      NotificationType.bookingCompleted => (Icons.check_circle, AppColors.secondary),
      NotificationType.promoNew => (Icons.campaign_rounded, AppColors.tertiary),
      NotificationType.reviewReply => (Icons.reply_rounded, AppColors.primary),
      NotificationType.badgeEarned => (Icons.star_rounded, AppColors.tertiary),
    };

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

// ---------------------------------------------------------------------------
// Body text with venue names highlighted in primary color
// ---------------------------------------------------------------------------

class _HighlightedBody extends StatelessWidget {
  const _HighlightedBody({required this.text});

  final String text;

  /// Known venue names to highlight.
  static const _venueNames = [
    'Sky Lounge Abidjan',
    'Lagoon Restaurant',
    'Quilox Nightclub',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodySmall?.copyWith(
          color: AppColors.onSurfaceVariant,
          height: 1.4,
        ) ??
        const TextStyle();

    final highlightStyle = baseStyle.copyWith(color: AppColors.primary);

    // Build spans by splitting on known venue names.
    final spans = <TextSpan>[];
    var remaining = text;

    while (remaining.isNotEmpty) {
      var earliestIndex = remaining.length;
      String? matchedName;

      for (final name in _venueNames) {
        final idx = remaining.indexOf(name);
        if (idx != -1 && idx < earliestIndex) {
          earliestIndex = idx;
          matchedName = name;
        }
      }

      if (matchedName == null) {
        spans.add(TextSpan(text: remaining, style: baseStyle));
        break;
      }

      if (earliestIndex > 0) {
        spans.add(TextSpan(text: remaining.substring(0, earliestIndex), style: baseStyle));
      }
      spans.add(TextSpan(text: matchedName, style: highlightStyle));
      remaining = remaining.substring(earliestIndex + matchedName.length);
    }

    return RichText(text: TextSpan(children: spans));
  }
}

// ---------------------------------------------------------------------------
// Bottom navigation bar
// ---------------------------------------------------------------------------

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.explore_outlined, label: 'Explore', isActive: false),
              _NavItem(icon: Icons.feed_outlined, label: 'Feed', isActive: false),
              _NavItem(icon: Icons.calendar_today_outlined, label: 'Bookings', isActive: false),
              _NavItem(icon: Icons.person, label: 'Profile', isActive: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.onSurfaceVariant;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
