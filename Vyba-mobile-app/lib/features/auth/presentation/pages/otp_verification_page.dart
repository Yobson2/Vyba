import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/extensions/context_extensions.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/data_display/app_glass_card.dart';
import 'package:flutter_templates/core/widgets/inputs/app_checkbox.dart';
import 'package:flutter_templates/core/widgets/inputs/app_otp_field.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_templates/features/auth/presentation/utils/otp_error_copy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// OTP verification page with countdown timer, resend and — on a first
/// sign-in only — the 18+ confirmation required by the nightlife context.
class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({
    required this.phoneNumber,
    required this.isFirstSignIn,
    super.key,
  });

  /// The phone number the code was sent to.
  final String phoneNumber;

  /// Whether this device has never completed a sign-in — shows the 18+
  /// confirmation when true.
  final bool isFirstSignIn;

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  static const _cooldownSeconds = 60;

  String _otpCode = '';
  bool _ageConfirmed = false;
  int _resendCountdown = _cooldownSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _resendCountdown = _cooldownSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _canSubmit =>
      _otpCode.length == 6 && (!widget.isFirstSignIn || _ageConfirmed);

  Future<void> _onVerify() async {
    if (!_canSubmit) return;
    context.unfocus();
    await ref.read(authNotifierProvider.notifier).verifyOtp(
          phoneNumber: widget.phoneNumber,
          code: _otpCode,
          ageConfirmed: widget.isFirstSignIn ? _ageConfirmed : null,
        );
  }

  void _onResend() {
    if (_resendCountdown > 0) return;
    _startCountdown();
    ref
        .read(authNotifierProvider.notifier)
        .requestOtp(phoneNumber: widget.phoneNumber);
  }

  String get _formattedCountdown {
    final minutes = (_resendCountdown ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendCountdown % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        context.showSnackBar(otpErrorMessage(state.code), isError: true);
      }
      if (state is AuthAuthenticated) {
        // Router redirect handles role-based navigation automatically.
        context.go('/');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Vyba',
          style: GoogleFonts.epilogue(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Vérifiez votre\nnuméro',
                style: GoogleFonts.epilogue(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  height: 1.1,
                ),
              ),
              AppSpacing.verticalMd,
              Text(
                'Un code à 6 chiffres a été envoyé au ${widget.phoneNumber}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              // OTP field
              AppOtpField(
                onChanged: (code) => setState(() => _otpCode = code),
                onCompleted: (_) {
                  if (_canSubmit) _onVerify();
                },
              ),
              if (widget.isFirstSignIn) ...[
                const SizedBox(height: 16),
                AppCheckbox(
                  value: _ageConfirmed,
                  onChanged: (value) =>
                      setState(() => _ageConfirmed = value ?? false),
                  label: "J'ai 18 ans ou plus.",
                ),
              ],
              const SizedBox(height: 24),
              // Confirm button
              AppGradientButton(
                onPressed: isLoading || !_canSubmit ? null : _onVerify,
                label: 'Confirmer',
                isLoading: isLoading,
              ),
              const SizedBox(height: 24),
              // Resend section
              Center(
                child: Text(
                  "Vous n'avez pas reçu de code ?",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ),
              AppSpacing.verticalSm,
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _resendCountdown == 0 ? _onResend : null,
                      child: Text(
                        'RENVOYER LE CODE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _resendCountdown == 0
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    if (_resendCountdown > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 14,
                        color: AppColors.outlineVariant,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.tertiaryFixed,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formattedCountdown,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.tertiaryFixed,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Encrypted connection card
              AppGlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerHighest,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connexion chiffrée',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.onSurface),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Votre vérification passe par un canal sécurisé.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Footer
              Center(
                child: Text(
                  'VYBA © 2026',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:
                            AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                        letterSpacing: 1.5,
                      ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
