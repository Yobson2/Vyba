import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCachedUserUseCase mockGetCachedUserUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCachedUserUseCase = MockGetCachedUserUseCase();
  });

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: '', password: ''),
    );
    registerFallbackValue(
      const RegisterParams(name: '', email: '', password: ''),
    );
    registerFallbackValue(
      const ForgotPasswordParams(email: ''),
    );
    registerFallbackValue(
      const VerifyOtpParams(email: '', code: ''),
    );
    registerFallbackValue(const NoParams());
  });

  const tUser = User(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
        registerUseCaseProvider.overrideWithValue(mockRegisterUseCase),
        forgotPasswordUseCaseProvider
            .overrideWithValue(mockForgotPasswordUseCase),
        verifyOtpUseCaseProvider.overrideWithValue(mockVerifyOtpUseCase),
        logoutUseCaseProvider.overrideWithValue(mockLogoutUseCase),
        getCachedUserUseCaseProvider
            .overrideWithValue(mockGetCachedUserUseCase),
      ],
    );
  }

  group('AuthNotifier', () {
    test('initial state should be AuthInitial', () {
      final container = createContainer();

      final state = container.read(authNotifierProvider);

      expect(state, isA<AuthInitial>());
    });

    test('login should update state to AuthAuthenticated on success', () async {
      // Arrange
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Right(tUser));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      // Act
      await notifier.login(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthAuthenticated>());
      expect((state as AuthAuthenticated).user, tUser);
    });

    test('login should update state to AuthError on failure', () async {
      // Arrange
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      // Act
      await notifier.login(
        email: 'test@example.com',
        password: 'wrong',
      );

      // Assert
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthError>());
    });

    test('logout should update state to AuthUnauthenticated', () async {
      // Arrange
      when(() => mockLogoutUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      // Act
      await notifier.logout();

      // Assert
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });
  });
}
