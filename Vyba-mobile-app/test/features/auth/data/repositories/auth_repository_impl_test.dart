import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/auth/data/models/tokens_model.dart';
import 'package:flutter_templates/features/auth/data/models/user_model.dart';
import 'package:flutter_templates/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const UserModel(id: '', email: '', name: ''),
    );
    registerFallbackValue(
      const TokensModel(accessToken: '', refreshToken: ''),
    );
  });

  const tUserModel = UserModel(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  const tTokensModel = TokensModel(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
  );

  const tUser = User(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  group('loginWithPhone', () {
    test('should check if device is online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.loginWithPhone(
          phoneNumber: any(named: 'phoneNumber'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async => (user: tUserModel, tokens: tTokensModel));
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async {});
      when(() => mockLocal.cacheTokens(any())).thenAnswer((_) async {});

      // Act
      await repository.loginWithPhone(
        phoneNumber: '+2250102030405',
        code: '123456',
      );

      // Assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return User when remote call succeeds', () async {
        // Arrange
        when(
          () => mockRemote.loginWithPhone(
            phoneNumber: any(named: 'phoneNumber'),
            code: any(named: 'code'),
          ),
        ).thenAnswer(
          (_) async => (user: tUserModel, tokens: tTokensModel),
        );
        when(() => mockLocal.cacheUser(any())).thenAnswer((_) async {});
        when(() => mockLocal.cacheTokens(any())).thenAnswer((_) async {});

        // Act
        final result = await repository.loginWithPhone(
          phoneNumber: '+2250102030405',
          code: '123456',
        );

        // Assert
        expect(result, const Right<Failure, User>(tUser));
      });

      test('should return ServerFailure when remote call fails', () async {
        // Arrange
        when(
          () => mockRemote.loginWithPhone(
            phoneNumber: any(named: 'phoneNumber'),
            code: any(named: 'code'),
          ),
        ).thenThrow(const ServerException(message: 'Invalid OTP'));

        // Act
        final result = await repository.loginWithPhone(
          phoneNumber: '+2250102030405',
          code: '123456',
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NetworkFailure', () async {
        // Act
        final result = await repository.loginWithPhone(
          phoneNumber: '+2250102030405',
          code: '123456',
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
        verifyZeroInteractions(mockRemote);
      });
    });
  });

  group('getCachedUser', () {
    test('should return cached user when available', () async {
      // Arrange
      when(() => mockLocal.getCachedUser()).thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.getCachedUser();

      // Assert
      expect(result, const Right<Failure, User>(tUser));
    });

    test('should return CacheFailure when no cached user', () async {
      // Arrange
      when(() => mockLocal.getCachedUser())
          .thenThrow(const CacheException(message: 'No cached user'));

      // Act
      final result = await repository.getCachedUser();

      // Assert
      expect(result, isA<Left<Failure, User>>());
    });
  });
}
