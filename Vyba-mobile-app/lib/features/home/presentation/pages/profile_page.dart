import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Vyba profile page with hero section and bento grid layout.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1a1040),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => context.push(
                                '${GoRouterState.of(context).matchedLocation}/settings',
                              ),
                              icon: const Icon(Icons.settings_outlined,
                                  color: AppColors.onSurfaceVariant),
                            ),
                            IconButton(
                              onPressed: () => context.push(
                                '${GoRouterState.of(context).matchedLocation}/notifications',
                              ),
                              icon: const Icon(Icons.notifications_outlined,
                                  color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        AppSpacing.verticalMd,
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 38,
                            backgroundColor: AppColors.surfaceContainerHigh,
                            child: Text(
                              user?.displayName.isNotEmpty == true
                                  ? user!.displayName[0].toUpperCase()
                                  : 'U',
                              style: GoogleFonts.epilogue(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.verticalMd,
                        Text(
                          user?.displayName ?? 'Invité',
                          style: GoogleFonts.epilogue(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        AppSpacing.verticalXs,
                        Text(
                          'VIP Member',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.tertiaryFixed,
                                    letterSpacing: 2,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Stats bento grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _StatCard(value: '12', label: 'Sorties'),
                  const SizedBox(width: 8),
                  _StatCard(value: '8', label: 'Favorites'),
                  const SizedBox(width: 8),
                  _StatCard(value: '5', label: 'Reviews'),
                ],
              ),
            ),
            AppSpacing.verticalXl,
            // Account Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Information',
                    style: GoogleFonts.epilogue(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  AppSpacing.verticalLg,
                  _InfoField(
                    label: 'Nom complet',
                    value: user?.displayName ?? '',
                  ),
                  _InfoField(
                    label: 'Téléphone',
                    value: user?.phoneNumber ?? '',
                  ),
                  AppSpacing.verticalXl,
                  _MenuItem(
                    icon: Icons.edit_outlined,
                    label: 'Edit Profile',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  AppSpacing.verticalXl,
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(authNotifierProvider.notifier).logout();
                      },
                      icon: const Icon(Icons.logout,
                          color: AppColors.error, size: 18),
                      label: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.error,
                            ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.epilogue(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.onSurfaceVariant, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
