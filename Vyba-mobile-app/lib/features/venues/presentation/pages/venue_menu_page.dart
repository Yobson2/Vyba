import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_menu.dart';
import 'package:flutter_templates/features/venues/presentation/providers/venue_providers.dart';
import 'package:google_fonts/google_fonts.dart';

class VenueMenuPage extends ConsumerWidget {
  const VenueMenuPage({required this.venueId, super.key});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Menu',
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: FutureBuilder(
        future: ref.read(getVenueMenuUseCaseProvider).call(venueId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return snapshot.data!.fold(
            (failure) => Center(child: Text(failure.message)),
            (menu) => _MenuContent(menu: menu),
          );
        },
      ),
    );
  }
}

class _MenuContent extends StatelessWidget {
  const _MenuContent({required this.menu});

  final VenueMenu menu;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: menu.categories.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: menu.categories
                .map((c) => Tab(text: c.name))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: menu.categories.map((category) {
                return ListView.separated(
                  padding: AppSpacing.paddingXl,
                  itemCount: category.items.length,
                  separatorBuilder: (_, __) => AppSpacing.verticalMd,
                  itemBuilder: (context, index) {
                    final item = category.items[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: AppRadius.borderRadiusMd,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: AppColors.onSurface),
                                ),
                                if (item.description != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            item.formattedPrice,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
