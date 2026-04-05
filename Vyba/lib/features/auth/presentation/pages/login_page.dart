import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/extensions/context_extensions.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/inputs/app_phone_field.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Phone-based login page with Lagos Pulse branding.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  String _countryCode = '+225';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    context.unfocus();
    // Navigate to OTP verification with phone number
    context.push('/otp-verification', extra: '$_countryCode $phone');
  }

  void _onGoogleLogin() {
    ref.read(authNotifierProvider.notifier).login(
          email: 'google@oauth.com',
          password: 'google_oauth',
        );
  }

  void _onAppleLogin() {
    ref.read(authNotifierProvider.notifier).login(
          email: 'apple@oauth.com',
          password: 'apple_oauth',
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        context.showSnackBar(state.message, isError: true);
      }
      if (state is AuthAuthenticated) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background hero image with gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  AppGradients.glassmorphicHeader.createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF1a0e3a),
                      Color(0xFF060e20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  // NP. Logo
                  Text(
                    'NP.',
                    style: GoogleFonts.epilogue(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // "Join the Pulse" headline
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Join the ',
                          style: GoogleFonts.epilogue(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                            height: 1.1,
                          ),
                        ),
                        TextSpan(
                          text: 'Pulse',
                          style: GoogleFonts.epilogue(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.verticalMd,
                  Text(
                    'Access the most exclusive nights in West Africa.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 40),
                  // Phone number section
                  Text(
                    'PHONE NUMBER',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 2,
                        ),
                  ),
                  AppSpacing.verticalSm,
                  AppPhoneField(
                    controller: _phoneController,
                    countryCode: _countryCode,
                    onCountryCodeChanged: (code) =>
                        setState(() => _countryCode = code),
                    hintText: '00 00 00 00',
                  ),
                  const SizedBox(height: 24),
                  // Continue button
                  AppGradientButton(
                    onPressed: isLoading ? null : _onContinue,
                    label: 'Continue',
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 32),
                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.outlineVariant.withValues(alpha: 0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR CURATED ENTRY VIA',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 1.5,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.outlineVariant.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Social login buttons
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.g_mobiledata_rounded,
                          label: 'Google',
                          onPressed: _onGoogleLogin,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.apple,
                          label: 'Apple',
                          onPressed: _onAppleLogin,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // Disclaimer
                  Center(
                    child: Text(
                      'BY CONTINUING, YOU AGREE TO OUR\nPRIVACY RITUALS & TERMS OF ACCESS',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                            letterSpacing: 1,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: AppColors.glassBg,
          child: InkWell(
            onTap: onPressed,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.onSurface, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.onSurface,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
