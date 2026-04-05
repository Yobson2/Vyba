import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/data_display/app_glass_card.dart';
import 'package:flutter_templates/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Vyba onboarding with step indicator bars and nightlife imagery.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();

  static const _steps = [
    _OnboardingData(
      title: "Discover What's\nHappening ",
      highlightedTitle: 'Tonight',
      subtitle:
          'Explore the hottest venues, live events, and exclusive nights across West Africa.',
      liveTag: 'Victoria Island',
    ),
    _OnboardingData(
      title: 'Book Your\n',
      highlightedTitle: 'Experience',
      subtitle:
          'Reserve VIP tables, skip the line, and secure your spot at the best venues.',
      liveTag: 'Lekki Phase 1',
    ),
    _OnboardingData(
      title: 'Own the\n',
      highlightedTitle: 'Night',
      subtitle:
          'Get personalized recommendations and real-time updates on the pulse of the city.',
      liveTag: 'Ikoyi',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onComplete() async {
    await ref.read(onboardingNotifierProvider.notifier).complete();
    if (mounted) context.go('/role-selection');
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: logo + skip
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: const Icon(
                          Icons.nightlife,
                          size: 16,
                          color: AppColors.onPrimaryFixed,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Vyba',
                        style: GoogleFonts.epilogue(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _onComplete,
                    child: Text(
                      'SKIP',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 2,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            // Step indicator bars
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(3, (index) {
                  final isActive = index <= currentPage;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            AppSpacing.verticalLg,
            // Content pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (page) {
                  ref.read(onboardingNotifierProvider.notifier).setPage(page);
                },
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Image placeholder
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.surfaceContainerHigh,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/onboarding_hero.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                  colors: [
                                    Color(0xBB060E20),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.verticalLg,
                        // Live Now glass card
                        AppGlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          borderRadius: BorderRadius.circular(999),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.secondaryContainer,
                                ),
                                child: const Icon(
                                  Icons.trending_up,
                                  size: 16,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'LIVE NOW',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.secondary,
                                          letterSpacing: 1.5,
                                          fontSize: 9,
                                        ),
                                  ),
                                  Text(
                                    step.liveTag,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: AppColors.onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.verticalXl,
                        // Title
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: step.title,
                                      style: GoogleFonts.epilogue(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.onSurface,
                                        height: 1.1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: step.highlightedTitle,
                                      style: GoogleFonts.epilogue(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              AppSpacing.verticalMd,
                              Text(
                                step.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: AppGradientButton(
                onPressed: () {
                  if (currentPage < 2) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _onComplete();
                  }
                },
                label: currentPage == 2 ? 'Get Started' : 'Next Step',
                icon: Icons.arrow_forward,
              ),
            ),
            // Footer
            Text(
              'POWERED BY LAGOS PULSE VIP NETWORK',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color:
                        AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    letterSpacing: 1.5,
                  ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.title,
    required this.highlightedTitle,
    required this.subtitle,
    required this.liveTag,
  });

  final String title;
  final String highlightedTitle;
  final String subtitle;
  final String liveTag;
}
