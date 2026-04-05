import 'package:flutter/material.dart';
import 'package:flutter_templates/core/extensions/context_extensions.dart';
import 'package:flutter_templates/core/widgets/layout/app_bottom_nav.dart';
import 'package:flutter_templates/core/widgets/layout/app_scaffold.dart';
import 'package:go_router/go_router.dart';

/// Shell wrapper for the home section with bottom navigation.
class HomeShell extends StatelessWidget {
  /// Creates a [HomeShell].
  const HomeShell({required this.navigationShell, super.key});

  /// GoRouter navigation shell for managing nested routes.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          AppBottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: l10n.homeTitle,
          ),
          AppBottomNavItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: l10n.profileTitle,
          ),
          AppBottomNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: l10n.settingsTitle,
          ),
        ],
      ),
    );
  }
}
