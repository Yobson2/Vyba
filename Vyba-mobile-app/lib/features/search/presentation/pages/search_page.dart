import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

/// Search & filter page with recent/trending pills, distance slider,
/// budget selector, min rating, and category bento grid.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  double _distance = 5.0;
  int _budgetLevel = 2;
  double _minRating = 3.0;

  static const _recentSearches = ['Zaza Abidjan', 'Rooftop bars', 'VIP'];
  static const _trendingSearches = [
    'Beach clubs',
    'Live music tonight',
    'Happy hour',
  ];
  static const _categories = [
    ('Clubs & Lounges', Icons.nightlife),
    ('Rooftops', Icons.roofing),
    ('Beach Clubs', Icons.beach_access),
    ('Restaurants', Icons.restaurant),
    ('Bars', Icons.local_bar),
    ('Live Music', Icons.music_note),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Search',
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search input
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: TextField(
                controller: _searchController,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.onSurface),
                decoration: const InputDecoration(
                  hintText: 'Search venues, events...',
                  prefixIcon:
                      Icon(Icons.search, color: AppColors.onSurfaceVariant),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            AppSpacing.verticalXl,
            // Recent searches
            _SectionLabel(
              label: 'RECENT',
              icon: Icons.history,
            ),
            AppSpacing.verticalSm,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches
                  .map((s) => _SearchPill(label: s, icon: Icons.history))
                  .toList(),
            ),
            AppSpacing.verticalLg,
            // Trending
            _SectionLabel(
              label: 'TRENDING',
              icon: Icons.trending_up,
            ),
            AppSpacing.verticalSm,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _trendingSearches
                  .map((s) => _SearchPill(
                        label: s,
                        icon: Icons.trending_up,
                        isTrending: true,
                      ))
                  .toList(),
            ),
            AppSpacing.verticalXl,
            // Filters
            Text(
              'Filters',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalLg,
            // Distance slider
            _FilterSection(
              label: 'Distance',
              trailing: '${_distance.toStringAsFixed(0)} km',
              child: Slider(
                value: _distance,
                min: 1,
                max: 20,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.surfaceContainerHighest,
                onChanged: (v) => setState(() => _distance = v),
              ),
            ),
            AppSpacing.verticalLg,
            // Budget scale
            _FilterSection(
              label: 'Budget',
              child: Row(
                children: List.generate(4, (index) {
                  final level = index + 1;
                  final isSelected = level <= _budgetLevel;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _budgetLevel = level),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surfaceContainerHighest,
                          borderRadius: AppRadius.borderRadiusSm,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          List.filled(level, '₦').join(),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: isSelected
                                    ? AppColors.onPrimaryFixed
                                    : AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            AppSpacing.verticalLg,
            // Min rating
            _FilterSection(
              label: 'Minimum Rating',
              trailing: _minRating.toStringAsFixed(1),
              child: Slider(
                value: _minRating,
                min: 1,
                max: 5,
                divisions: 8,
                activeColor: AppColors.tertiaryFixed,
                inactiveColor: AppColors.surfaceContainerHighest,
                onChanged: (v) => setState(() => _minRating = v),
              ),
            ),
            AppSpacing.verticalXl,
            // Category bento
            Text(
              'Categories',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalMd,
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
              children: _categories.map((c) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: AppRadius.borderRadiusMd,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(c.$2,
                                color: AppColors.primary, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                c.$1,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: AppColors.onSurface),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 2,
              ),
        ),
      ],
    );
  }
}

class _SearchPill extends StatelessWidget {
  const _SearchPill({
    required this.label,
    required this.icon,
    this.isTrending = false,
  });

  final String label;
  final IconData icon;
  final bool isTrending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isTrending
                  ? AppColors.secondary
                  : AppColors.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.label,
    required this.child,
    this.trailing,
  });

  final String label;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
