import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/data_display/app_glass_card.dart';
import 'package:flutter_templates/features/role_selection/presentation/providers/role_selection_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Role selection page — choose Client or Venue Owner.
class RoleSelectionPage extends ConsumerWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(selectedRoleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Header
              Center(
                child: Text(
                  'Vyba',
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'How will you use\nVyba?',
                style: GoogleFonts.epilogue(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  height: 1.15,
                ),
              ),
              AppSpacing.verticalSm,
              Text(
                'Select your journey to unlock a curated nightlife experience tailored to your rhythm.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              // Role cards
              Expanded(
                child: Column(
                  children: [
                    _RoleCard(
                      title: "I'm a Client",
                      description:
                          'Discover the hottest maquis, book exclusive tables & lounges, and taste the pulse of the city\'s elite venues.',
                      role: UserRole.client,
                      isSelected: selectedRole == UserRole.client,
                      onTap: () => ref
                          .read(selectedRoleProvider.notifier)
                          .select(UserRole.client),
                      imageIcon: Icons.nightlife,
                    ),
                    const SizedBox(height: 16),
                    _RoleCard(
                      title: "I'm a Venue Owner",
                      description:
                          'Showcase your lounge, bar or maquis, manage exclusive events, and engage with your city\'s most discerning crowd.',
                      role: UserRole.venueOwner,
                      isSelected: selectedRole == UserRole.venueOwner,
                      onTap: () => ref
                          .read(selectedRoleProvider.notifier)
                          .select(UserRole.venueOwner),
                      imageIcon: Icons.store,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Get Started button
              AppGradientButton(
                onPressed: selectedRole != null
                    ? () async {
                        await ref
                            .read(setUserRoleUseCaseProvider)
                            .call(selectedRole);
                        if (context.mounted) {
                          context.go('/login');
                        }
                      }
                    : null,
                label: 'Get Started',
                icon: Icons.arrow_forward,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.role,
    required this.isSelected,
    required this.onTap,
    required this.imageIcon,
  });

  final String title;
  final String description;
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData imageIcon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 2)
                : Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.1)),
          ),
          child: Stack(
            children: [
              // Background icon
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  imageIcon,
                  size: 120,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Radio indicator
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          width: 2,
                        ),
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              size: 16, color: AppColors.onPrimaryFixed)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: GoogleFonts.epilogue(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
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
