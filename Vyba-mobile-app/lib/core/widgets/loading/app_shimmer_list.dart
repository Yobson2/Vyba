import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/loading/app_shimmer.dart';

/// Shimmer loading list placeholder.
///
/// Renders [itemCount] shimmer rows to mimic a loading list.
class AppShimmerList extends StatelessWidget {
  /// Creates an [AppShimmerList].
  const AppShimmerList({
    super.key,
    this.itemCount = 5,
    this.padding,
  });

  /// Number of shimmer items.
  final int itemCount;

  /// List padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? AppSpacing.paddingLg,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => AppSpacing.verticalLg,
      itemBuilder: (_, __) => const _ShimmerListItem(),
    );
  }
}

class _ShimmerListItem extends StatelessWidget {
  const _ShimmerListItem();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppShimmer(
            width: 48, height: 48, borderRadius: BorderRadius.zero),
        AppSpacing.horizontalMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppShimmer(height: 14, width: 160),
              SizedBox(height: 8),
              AppShimmer(height: 12, width: 100),
            ],
          ),
        ),
      ],
    );
  }
}
