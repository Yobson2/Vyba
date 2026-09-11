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
import 'package:flutter_templates/features/auth/presentation/utils/otp_error_copy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Phone-based login page with Vyba branding.
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

  String get _normalizedPhone {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    return '$_countryCode$digits';
  }

  void _onContinue() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    context.unfocus();
    ref
        .read(authNotifierProvider.notifier)
        .requestOtp(phoneNumber: _normalizedPhone);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        context.showSnackBar(otpErrorMessage(state.code), isError: true);
      }
      if (state is AuthCodeRequested) {
        context.push(
          '/otp-verification',
          extra: (
            phoneNumber: state.phoneNumber,
            isFirstSignIn: state.isFirstSignIn,
          ),
        );
      }
      if (state is AuthAuthenticated) {
        // Router redirect handles role-based navigation automatically.
        context.go('/');
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
                  // Vyba Logo
                  Text(
                    'Vyba',
                    style: GoogleFonts.epilogue(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bienvenue sur ',
                          style: GoogleFonts.epilogue(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                            height: 1.1,
                          ),
                        ),
                        TextSpan(
                          text: 'Vyba',
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
                    'Découvrez les meilleures soirées de la Zone 4.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 40),
                  // Phone number section
                  Text(
                    'NUMÉRO DE TÉLÉPHONE',
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
                    label: 'Continuer',
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 48),
                  // Disclaimer
                  Center(
                    child: Text(
                      "EN CONTINUANT, VOUS ACCEPTEZ NOS CONDITIONS\nD'UTILISATION ET NOTRE POLITIQUE DE CONFIDENTIALITÉ",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant
                                .withValues(alpha: 0.5),
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
