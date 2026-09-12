import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/config/env_provider.dart';
import 'package:flutter_templates/core/router/route_names.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Builds the WhatsApp deep link used by the "Un problème ?" support entry,
/// from a WhatsApp [number] in international format (digits only).
Uri buildWhatsAppSupportUri(String number) {
  return Uri.parse('https://wa.me/$number');
}

/// Vyba settings page, trimmed to the validation scope: notification
/// preferences (placeholder), support via WhatsApp, legal links
/// (placeholder), sign out, and delete account (placeholder).
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _openWhatsAppSupport(BuildContext context, WidgetRef ref) async {
    final number = ref.read(envProvider).supportWhatsappNumber;
    final uri = buildWhatsAppSupportUri(number);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir WhatsApp.")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Paramètres',
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
            // Notifications section
            Text(
              'Notifications',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalMd,
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Préférences de notification',
              onTap: () =>
                  context.pushNamed(RouteNames.notificationPreferencesName),
            ),
            AppSpacing.verticalXl,
            // Support section
            Text(
              'Assistance',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalMd,
            _SettingsTile(
              icon: Icons.chat_outlined,
              title: 'Un problème ?',
              onTap: () => _openWhatsAppSupport(context, ref),
            ),
            AppSpacing.verticalXl,
            // Legal section
            Text(
              'Légal',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalMd,
            _SettingsTile(
              icon: Icons.description_outlined,
              title: "Conditions d'utilisation",
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Politique de confidentialité',
              onTap: () {},
            ),
            AppSpacing.verticalXl,
            // Account section
            Text(
              'Compte',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            AppSpacing.verticalMd,
            _SettingsTile(
              icon: Icons.logout,
              title: 'Se déconnecter',
              onTap: () => ref.read(authNotifierProvider.notifier).logout(),
            ),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Supprimer mon compte',
              titleColor: AppColors.error,
              onTap: () {},
            ),
            const SizedBox(height: 100),
          ],
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
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? titleColor;

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
              Icon(
                icon,
                color: titleColor ?? AppColors.onSurfaceVariant,
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: titleColor ?? AppColors.onSurface,
                      ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
