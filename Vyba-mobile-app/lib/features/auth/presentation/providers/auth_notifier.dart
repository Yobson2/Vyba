import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/login_with_phone_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

/// Manages authentication state and actions.
///
/// Uses [Notifier] pattern (Riverpod 2.0+) for synchronous state
/// with async side effects.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  /// Attempts to log in with phone number and OTP code.
  Future<void> loginWithPhone({
    required String phoneNumber,
    required String code,
  }) async {
    state = const AuthState.loading();
    try {
      final result = await ref.read(loginWithPhoneUseCaseProvider).call(
            LoginWithPhoneParams(phoneNumber: phoneNumber, code: code),
          );
      state = result.fold(
        (failure) => AuthState.error(failure.message),
        AuthState.authenticated,
      );
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Verifies the OTP code.
  Future<bool> verifyOtp({
    required String email,
    required String code,
  }) async {
    state = const AuthState.loading();
    final result = await ref.read(verifyOtpUseCaseProvider).call(
          VerifyOtpParams(email: email, code: code),
        );
    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.unauthenticated();
        return true;
      },
    );
  }

  /// Logs the user out.
  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      final result =
          await ref.read(logoutUseCaseProvider).call(const NoParams());
      result.fold(
        (failure) => state = AuthState.error(failure.message),
        (_) => state = const AuthState.unauthenticated(),
      );
    } catch (_) {
      // Even on error, force unauthenticated to clear local state.
      state = const AuthState.unauthenticated();
    }
  }

  /// Checks for a cached user session on app launch.
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    final result =
        await ref.read(getCachedUserUseCaseProvider).call(const NoParams());
    state = result.fold(
      (_) => const AuthState.unauthenticated(),
      AuthState.authenticated,
    );
  }
}
