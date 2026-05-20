import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/owner_analytics/domain/entities/analytics_data.dart';
import 'package:flutter_templates/features/owner_analytics/presentation/providers/analytics_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OwnerAnalyticsPage extends ConsumerStatefulWidget {
  const OwnerAnalyticsPage({super.key});

  @override
  ConsumerState<OwnerAnalyticsPage> createState() =>
      _OwnerAnalyticsPageState();
}

class _OwnerAnalyticsPageState extends ConsumerState<OwnerAnalyticsPage> {
  int _selectedRange = 0;
  static const _ranges = ['week', 'month', 'all'];
  static const _rangeLabels = ['This Week', 'This Month', 'All Time'];

  @override
  Widget build(BuildContext context) {
    final analyticsAsync =
        ref.watch(ownerAnalyticsProvider(dateRange: _ranges[_selectedRange]));

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
              Text(
                'Analytics',
                style: GoogleFonts.epilogue(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              AppSpacing.verticalXl,

              // Date range selector
              Row(
                children: List.generate(_rangeLabels.length, (index) {
                  final isSelected = index == _selectedRange;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedRange = index),
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
                          _rangeLabels[index],
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
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
                }),
              ),

              AppSpacing.verticalXl,

              analyticsAsync.when(
                data: (AnalyticsData data) => _AnalyticsContent(data: data),
                loading: () => const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Failed to load analytics',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({required this.data});

  final AnalyticsData data;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2x2 metric cards
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Total Bookings',
                value: '${data.totalBookings}',
                icon: Icons.event_rounded,
                iconColor: AppColors.primary,
              ),
            ),
            AppSpacing.horizontalSm,
            Expanded(
              child: _MetricCard(
                label: 'Total Views',
                value: _formatNumber(data.totalViews),
                icon: Icons.visibility_rounded,
                iconColor: AppColors.info,
              ),
            ),
          ],
        ),
        AppSpacing.verticalSm,
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Avg Rating',
                value: data.averageRating.toStringAsFixed(1),
                icon: Icons.star_rounded,
                iconColor: AppColors.tertiary,
              ),
            ),
            AppSpacing.horizontalSm,
            Expanded(
              child: _MetricCard(
                label: 'Revenue',
                value: currencyFormat.format(data.revenueEstimate),
                icon: Icons.payments_rounded,
                iconColor: AppColors.success,
              ),
            ),
          ],
        ),

        AppSpacing.verticalXxl,

        // Booking trend bar chart
        Text(
          'Booking Trend',
          style: GoogleFonts.epilogue(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        AppSpacing.verticalLg,
        _BarChart(bookingsByDay: data.bookingsByDay),

        AppSpacing.verticalXxl,

        // Booking summary
        Text(
          'Booking Summary',
          style: GoogleFonts.epilogue(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        AppSpacing.verticalLg,
        _SummaryRow(
          label: 'Peak Day',
          value: _getPeakDay(data.bookingsByDay),
        ),
        _SummaryRow(
          label: 'Daily Average',
          value:
              '${(data.bookingsByDay.fold<int>(0, (sum, e) => sum + e.value) / data.bookingsByDay.length).toStringAsFixed(1)} bookings',
        ),
        const _SummaryRow(
          label: 'Busiest Time',
          value: '9:00 PM - 11:00 PM',
        ),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  String _getPeakDay(List<MapEntry<String, int>> entries) {
    var maxEntry = entries.first;
    for (final entry in entries) {
      if (entry.value > maxEntry.value) maxEntry = entry;
    }
    return '${maxEntry.key} (${maxEntry.value} bookings)';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          AppSpacing.verticalMd,
          Text(
            value,
            style: GoogleFonts.epilogue(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.verticalXs,
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.bookingsByDay});

  final List<MapEntry<String, int>> bookingsByDay;

  @override
  Widget build(BuildContext context) {
    final maxValue =
        bookingsByDay.fold<int>(0, (max, e) => e.value > max ? e.value : max);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: SizedBox(
        height: 180,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: bookingsByDay.map((entry) {
            final ratio = maxValue > 0 ? entry.value / maxValue : 0.0;
            final barHeight = math.max(ratio * 140, 4.0);
            return Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${entry.value}',
                      style:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 10,
                              ),
                    ),
                    AppSpacing.verticalXs,
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(
                          alpha: 0.4 + (ratio * 0.6),
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadius.xs),
                        ),
                      ),
                    ),
                    AppSpacing.verticalXs,
                    Text(
                      entry.key,
                      style:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 10,
                              ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: AppRadius.borderRadiusSm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
