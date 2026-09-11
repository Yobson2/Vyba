import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/owner_dashboard/domain/entities/activity_item.dart';
import 'package:flutter_templates/features/owner_dashboard/presentation/providers/owner_dashboard_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OwnerDashboardPage extends ConsumerWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final activityAsync = ref.watch(recentActivityProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting header
              _GreetingHeader(),

              AppSpacing.verticalXl,

              // Stats row
              statsAsync.when(
                data: (stats) => _StatsRow(
                  todayVisits: stats.todayVisits,
                  activePromos: stats.activePromos,
                  weekViews: stats.formattedViews,
                  visitsTrend: stats.visitsTrend,
                ),
                loading: () => const SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                error: (e, _) => Text(
                  'Failed to load stats',
                  style: TextStyle(color: AppColors.error),
                ),
              ),

              AppSpacing.verticalXl,

              // Quick Studio Actions
              Text(
                'Quick Studio Actions',
                style: GoogleFonts.epilogue(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              AppSpacing.verticalLg,
              const _QuickActionsGrid(),

              AppSpacing.verticalXl,

              // Activity
              Text(
                'Activity',
                style: GoogleFonts.epilogue(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              AppSpacing.verticalLg,
              activityAsync.when(
                data: (activities) => Column(
                  children: activities
                      .map((item) => _ActivityTimelineItem(item: item))
                      .toList(),
                ),
                loading: () => const SizedBox(
                  height: 80,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                error: (e, _) => Text(
                  'Failed to load activity',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEE, MMMM d, yyyy').format(now).toUpperCase();
    final hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, Malik',
          style: GoogleFonts.epilogue(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        AppSpacing.verticalXs,
        Text(
          dateStr,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
              ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.todayVisits,
    required this.activePromos,
    required this.weekViews,
    required this.visitsTrend,
  });

  final int todayVisits;
  final int activePromos;
  final String weekViews;
  final double visitsTrend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '$todayVisits',
            label: "Today's Visits",
            trailing: _TrendBadge(value: visitsTrend),
          ),
        ),
        AppSpacing.horizontalSm,
        Expanded(
          child: _StatCard(
            value: activePromos.toString().padLeft(2, '0'),
            label: 'Active Promos',
            trailing: Icon(
              Icons.campaign_rounded,
              color: AppColors.tertiary,
              size: 18,
            ),
          ),
        ),
        AppSpacing.horizontalSm,
        Expanded(
          child: _StatCard(
            value: weekViews,
            label: "This Week's Views",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'LIVE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.success,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.trailing,
  });

  final String value;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (trailing != null) ...[
            Align(alignment: Alignment.topRight, child: trailing),
            AppSpacing.verticalXs,
          ],
          Text(
            value,
            style: GoogleFonts.epilogue(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          AppSpacing.verticalXs,
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: (isPositive ? AppColors.success : AppColors.error)
            .withValues(alpha: 0.15),
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 12,
            color: isPositive ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 2),
          Text(
            '${isPositive ? '+' : ''}${value.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isPositive ? AppColors.success : AppColors.error,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.local_offer_rounded,
                label: 'Add Promo',
                gradient: AppGradients.primaryButton,
                onTap: () {},
              ),
            ),
            AppSpacing.horizontalSm,
            Expanded(
              child: _ActionButton(
                icon: Icons.schedule_rounded,
                label: 'Update\nAvailability',
                onTap: () {},
              ),
            ),
          ],
        ),
        AppSpacing.verticalSm,
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.analytics_rounded,
                label: 'View\nAnalytics',
                onTap: () {},
              ),
            ),
            AppSpacing.horizontalSm,
            Expanded(
              child: _ActionButton(
                icon: Icons.store_rounded,
                label: 'Manage\nVenues',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.gradient,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? AppColors.surfaceContainerHigh : null,
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: gradient != null
                  ? AppColors.onPrimaryFixed
                  : AppColors.onSurface,
              size: 22,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: gradient != null
                        ? AppColors.onPrimaryFixed
                        : AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTimelineItem extends StatelessWidget {
  const _ActivityTimelineItem({required this.item});

  final ActivityItem item;

  IconData get _icon {
    switch (item.type) {
      case ActivityType.checkIn:
        return Icons.event_available_rounded;
      case ActivityType.review:
        return Icons.star_rounded;
      case ActivityType.promo:
        return Icons.campaign_rounded;
      case ActivityType.system:
        return Icons.info_outline_rounded;
    }
  }

  Color get _iconColor {
    switch (item.type) {
      case ActivityType.checkIn:
        return AppColors.success;
      case ActivityType.review:
        return AppColors.tertiary;
      case ActivityType.promo:
        return AppColors.primary;
      case ActivityType.system:
        return AppColors.info;
    }
  }

  String get _timeAgo {
    final diff = DateTime.now().difference(item.timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, size: 18, color: _iconColor),
          ),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                AppSpacing.verticalXs,
                Text(
                  _timeAgo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
