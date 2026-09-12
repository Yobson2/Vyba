import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/restore_session_usecase.dart';
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

  /// Requests (or resends) a code for [phoneNumber].
  Future<void> requestOtp({required String phoneNumber}) async {
    state = const AuthState.loading();
    final result = await ref.read(requestOtpUseCaseProvider).call(
          RequestOtpParams(phoneNumber: phoneNumber),
        );
    state = await result.fold(
      (failure) async => AuthState.error(failure.message, code: failure.code),
      (_) async {
        final hasSignedInBefore =
            await ref.read(authLocalDataSourceProvider).hasEverSignedIn();
        return AuthState.codeRequested(
          phoneNumber: phoneNumber,
          isFirstSignIn: !hasSignedInBefore,
        );
      },
    );
  }

  /// Verifies the OTP code and, on success, signs the user in.
  Future<void> verifyOtp({
    required String phoneNumber,
    required String code,
    bool? ageConfirmed,
  }) async {
    state = const AuthState.loading();
    final clientId = ref.read(localStorageProvider).getOrCreateClientId();
    final result = await ref.read(verifyOtpUseCaseProvider).call(
          VerifyOtpParams(
            phoneNumber: phoneNumber,
            code: code,
            ageConfirmed: ageConfirmed,
            clientId: clientId,
          ),
        );
    state = result.fold(
      (failure) => AuthState.error(failure.message, code: failure.code),
      AuthState.authenticated,
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

  /// Restores the session on app launch: cached user if the access token is
  /// still valid, refreshed first if it has expired, unauthenticated
  /// otherwise.
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    final result =
        await ref.read(restoreSessionUseCaseProvider).call(const NoParams());
    state = result.fold(
      (_) => const AuthState.unauthenticated(),
      AuthState.authenticated,
    );
  }
}
