import 'dart:convert';

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
    registerFallbackValue(const UserModel(id: '', phone: ''));
    registerFallbackValue(
      const TokensModel(accessToken: '', refreshToken: ''),
    );
  });

  const tUserModel = UserModel(id: '1', phone: '+2250102030405');
  const tTokensModel = TokensModel(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
  );
  const tUser = User(id: '1', phoneNumber: '+2250102030405');

  group('requestOtp', () {
    test('should return NetworkFailure when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.requestOtp(phoneNumber: '+2250102030405');

      expect(result, isA<Left<Failure, void>>());
      verifyZeroInteractions(mockRemote);
    });

    test('should return Right when the remote call succeeds', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.requestOtp(phoneNumber: any(named: 'phoneNumber')))
          .thenAnswer((_) async {});

      final result = await repository.requestOtp(phoneNumber: '+2250102030405');

      expect(result, const Right<Failure, void>(null));
    });

    test('should return a Failure carrying the backend code on rate limit',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.requestOtp(phoneNumber: any(named: 'phoneNumber')))
          .thenThrow(
        const ServerException(
          message: 'Too many attempts',
          statusCode: 429,
          code: 'AUTH_RATE_002',
        ),
      );

      final result = await repository.requestOtp(phoneNumber: '+2250102030405');

      expect(result, isA<Left<Failure, void>>());
      result.fold(
        (failure) => expect(failure.code, 'AUTH_RATE_002'),
        (_) => fail('expected a Left'),
      );
    });
  });

  group('verifyOtp', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async {});
      when(() => mockLocal.cacheTokens(any())).thenAnswer((_) async {});
      when(() => mockLocal.markSignedIn()).thenAnswer((_) async {});
    });

    test('should return User when the remote call succeeds', () async {
      when(
        () => mockRemote.verifyOtp(
          phoneNumber: any(named: 'phoneNumber'),
          code: any(named: 'code'),
          ageConfirmed: any(named: 'ageConfirmed'),
        ),
      ).thenAnswer((_) async => (user: tUserModel, tokens: tTokensModel));

      final result = await repository.verifyOtp(
        phoneNumber: '+2250102030405',
        code: '123456',
        ageConfirmed: true,
      );

      expect(result, const Right<Failure, User>(tUser));
      verify(() => mockLocal.markSignedIn()).called(1);
    });

    test('should return a Failure carrying the backend code on a wrong code',
        () async {
      when(
        () => mockRemote.verifyOtp(
          phoneNumber: any(named: 'phoneNumber'),
          code: any(named: 'code'),
          ageConfirmed: any(named: 'ageConfirmed'),
        ),
      ).thenThrow(
        const ServerException(
          message: 'The code is incorrect',
          statusCode: 401,
          code: 'AUTH_VERIFY_001',
        ),
      );

      final result = await repository.verifyOtp(
        phoneNumber: '+2250102030405',
        code: 'wrong0',
      );

      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (failure) => expect(failure.code, 'AUTH_VERIFY_001'),
        (_) => fail('expected a Left'),
      );
    });

    test('should return NetworkFailure when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.verifyOtp(
        phoneNumber: '+2250102030405',
        code: '123456',
      );

      expect(result, isA<Left<Failure, User>>());
      verifyZeroInteractions(mockRemote);
    });
  });

  group('getCachedUser', () {
    test('should return cached user when available', () async {
      when(() => mockLocal.getCachedUser()).thenAnswer((_) async => tUserModel);

      final result = await repository.getCachedUser();

      expect(result, const Right<Failure, User>(tUser));
    });

    test('should return CacheFailure when no cached user', () async {
      when(() => mockLocal.getCachedUser())
          .thenThrow(const CacheException(message: 'No cached user'));

      final result = await repository.getCachedUser();

      expect(result, isA<Left<Failure, User>>());
    });
  });

  group('restoreSession', () {
    test(
        'returns the cached user without a network call when the access '
        'token is still valid', () async {
      when(() => mockLocal.getCachedUser()).thenAnswer((_) async => tUserModel);
      when(() => mockLocal.getAccessToken())
          .thenAnswer((_) async => _validJwt());

      final result = await repository.restoreSession();

      expect(result, const Right<Failure, User>(tUser));
      verifyZeroInteractions(mockRemote);
    });

    test('refreshes when the access token has expired', () async {
      when(() => mockLocal.getCachedUser()).thenAnswer((_) async => tUserModel);
      when(() => mockLocal.getAccessToken())
          .thenAnswer((_) async => _expiredJwt());
      when(() => mockLocal.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.refresh(refreshToken: any(named: 'refreshToken')))
          .thenAnswer((_) async => (user: tUserModel, tokens: tTokensModel));
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async {});
      when(() => mockLocal.cacheTokens(any())).thenAnswer((_) async {});

      final result = await repository.restoreSession();

      expect(result, const Right<Failure, User>(tUser));
      verify(() => mockRemote.refresh(refreshToken: 'refresh_token')).called(1);
    });

    test('clears the session and returns unauthorized when refresh fails',
        () async {
      when(() => mockLocal.getCachedUser()).thenAnswer((_) async => tUserModel);
      when(() => mockLocal.getAccessToken())
          .thenAnswer((_) async => _expiredJwt());
      when(() => mockLocal.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.refresh(refreshToken: any(named: 'refreshToken')))
          .thenThrow(const UnauthorizedException(message: 'Invalid refresh'));
      when(() => mockLocal.clearAll()).thenAnswer((_) async {});

      final result = await repository.restoreSession();

      expect(result, isA<Left<Failure, User>>());
      verify(() => mockLocal.clearAll()).called(1);
    });
  });
}

/// A JWT with an `exp` far in the future. Signature is not verified client-side.
String _validJwt() => _jwtWithExp(
      DateTime.now().toUtc().add(const Duration(hours: 1)),
    );

/// A JWT with an `exp` in the past.
String _expiredJwt() => _jwtWithExp(
      DateTime.now().toUtc().subtract(const Duration(hours: 1)),
    );

/// Builds a JWT with just enough shape for [jwtExpiry] to parse: three
/// dot-separated segments, a base64url payload carrying `exp`. The header
/// and signature content are never inspected client-side.
String _jwtWithExp(DateTime exp) {
  final expSeconds = exp.millisecondsSinceEpoch ~/ 1000;
  final payload =
      base64Url.encode('{"exp":$expSeconds}'.codeUnits).replaceAll('=', '');
  return 'header.$payload.signature';
}
