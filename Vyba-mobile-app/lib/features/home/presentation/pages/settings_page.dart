import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/theme/theme_provider.dart';
import 'package:flutter_templates/core/widgets/data_display/app_glass_card.dart';
import 'package:google_fonts/google_fonts.dart';

/// Vyba settings page with glass cards and theme/language selectors.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
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
            AppSpacing.verticalLg,
            // Appearance section
            Text(
              'Appearance',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalMd,
            // Theme picker
            AppGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.onSurface,
                        ),
                  ),
                  AppSpacing.verticalMd,
                  Row(
                    children: [
                      _ThemeOption(
                        label: 'Dark',
                        icon: Icons.dark_mode,
                        isSelected: themeMode == ThemeMode.dark,
                        onTap: () => ref
                            .read(themeModeNotifierProvider.notifier)
                            .setThemeMode(ThemeMode.dark),
                      ),
                      const SizedBox(width: 8),
                      _ThemeOption(
                        label: 'Light',
                        icon: Icons.light_mode,
                        isSelected: themeMode == ThemeMode.light,
                        onTap: () => ref
                            .read(themeModeNotifierProvider.notifier)
                            .setThemeMode(ThemeMode.light),
                      ),
                      const SizedBox(width: 8),
                      _ThemeOption(
                        label: 'System',
                        icon: Icons.settings_brightness,
                        isSelected: themeMode == ThemeMode.system,
                        onTap: () => ref
                            .read(themeModeNotifierProvider.notifier)
                            .setThemeMode(ThemeMode.system),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.verticalMd,
            // Language selector
            AppGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Language',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.onSurface,
                        ),
                  ),
                  AppSpacing.verticalMd,
                  Row(
                    children: [
                      _LanguageOption(
                        label: 'EN',
                        isSelected: true,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _LanguageOption(
                        label: 'FR',
                        isSelected: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.verticalXl,
            // Security section
            Text(
              'Security',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalMd,
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.fingerprint,
              title: 'Biometric Login',
              trailing: Switch(
                value: false,
                onChanged: (_) {},
                activeColor: AppColors.primary,
              ),
            ),
            AppSpacing.verticalXl,
            // About section
            Text(
              'About',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalMd,
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'App Version',
              trailing: Text(
                '1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {},
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.surfaceContainerHighest,
            borderRadius: AppRadius.borderRadiusSm,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.onPrimaryFixed
                    : AppColors.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceContainerHighest,
          borderRadius: AppRadius.borderRadiusSm,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? AppColors.onPrimaryFixed
                    : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

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
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
              ),
              trailing ??
                  const Icon(Icons.chevron_right,
                      color: AppColors.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
