import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockRequestOtpUseCase mockRequestOtpUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCachedUserUseCase mockGetCachedUserUseCase;
  late MockRestoreSessionUseCase mockRestoreSessionUseCase;
  late MockAuthLocalDataSource mockAuthLocalDataSource;

  setUp(() {
    mockRequestOtpUseCase = MockRequestOtpUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCachedUserUseCase = MockGetCachedUserUseCase();
    mockRestoreSessionUseCase = MockRestoreSessionUseCase();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
  });

  setUpAll(() {
    registerFallbackValue(const RequestOtpParams(phoneNumber: ''));
    registerFallbackValue(const VerifyOtpParams(phoneNumber: '', code: ''));
    registerFallbackValue(const NoParams());
  });

  const tUser = User(id: '1', phoneNumber: '+2250102030405');

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        requestOtpUseCaseProvider.overrideWithValue(mockRequestOtpUseCase),
        verifyOtpUseCaseProvider.overrideWithValue(mockVerifyOtpUseCase),
        logoutUseCaseProvider.overrideWithValue(mockLogoutUseCase),
        getCachedUserUseCaseProvider
            .overrideWithValue(mockGetCachedUserUseCase),
        restoreSessionUseCaseProvider
            .overrideWithValue(mockRestoreSessionUseCase),
        authLocalDataSourceProvider.overrideWithValue(mockAuthLocalDataSource),
      ],
    );
  }

  group('AuthNotifier', () {
    test('initial state should be AuthInitial', () {
      final container = createContainer();

      final state = container.read(authNotifierProvider);

      expect(state, isA<AuthInitial>());
    });

    test('requestOtp moves to AuthCodeRequested, first sign-in flagged',
        () async {
      when(() => mockRequestOtpUseCase(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockAuthLocalDataSource.hasEverSignedIn())
          .thenAnswer((_) async => false);

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.requestOtp(phoneNumber: '+2250102030405');

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthCodeRequested>());
      expect((state as AuthCodeRequested).phoneNumber, '+2250102030405');
      expect(state.isFirstSignIn, isTrue);
    });

    test(
        'requestOtp updates state to AuthError with the backend code on '
        'failure', () async {
      when(() => mockRequestOtpUseCase(any())).thenAnswer(
        (_) async => const Left(
          ServerFailure(message: 'Too many attempts', code: 'AUTH_RATE_002'),
        ),
      );

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.requestOtp(phoneNumber: '+2250102030405');

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthError>());
      expect((state as AuthError).code, 'AUTH_RATE_002');
    });

    test('verifyOtp updates state to AuthAuthenticated on success', () async {
      when(() => mockVerifyOtpUseCase(any()))
          .thenAnswer((_) async => const Right(tUser));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.verifyOtp(
        phoneNumber: '+2250102030405',
        code: '123456',
        ageConfirmed: true,
      );

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthAuthenticated>());
      expect((state as AuthAuthenticated).user, tUser);
    });

    test(
        'verifyOtp updates state to AuthError with the mapped code on a '
        'wrong code', () async {
      when(() => mockVerifyOtpUseCase(any())).thenAnswer(
        (_) async => const Left(
          ServerFailure(
              message: 'The code is incorrect', code: 'AUTH_VERIFY_001'),
        ),
      );

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.verifyOtp(phoneNumber: '+2250102030405', code: 'wrong0');

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthError>());
      expect((state as AuthError).code, 'AUTH_VERIFY_001');
    });

    test('logout should update state to AuthUnauthenticated', () async {
      when(() => mockLogoutUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.logout();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });

    test('checkAuthStatus authenticates from a restored session', () async {
      when(() => mockRestoreSessionUseCase(any()))
          .thenAnswer((_) async => const Right(tUser));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.checkAuthStatus();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthAuthenticated>());
      expect((state as AuthAuthenticated).user, tUser);
    });

    test(
        'checkAuthStatus is unauthenticated when the session cannot be '
        'restored', () async {
      when(() => mockRestoreSessionUseCase(any())).thenAnswer(
        (_) async => const Left(UnauthorizedFailure()),
      );

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      await notifier.checkAuthStatus();

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });
  });
}
