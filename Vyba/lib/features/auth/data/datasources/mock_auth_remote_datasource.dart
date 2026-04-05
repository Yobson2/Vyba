// coverage:ignore-file

import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_templates/features/auth/data/models/tokens_model.dart';
import 'package:flutter_templates/features/auth/data/models/user_model.dart';

/// Mock implementation of [AuthRemoteDataSource] for local testing.
///
/// Credentials: `test@test.com` / `password`
///
/// Remove this file and set `USE_MOCK_AUTH=false` in `.env` to switch
/// to the real API.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  static const _delay = Duration(milliseconds: 800);

  static const _email = 'test@gmail.com';
  static const _password = 'passworD@123';

  static const _mockUser = UserModel(
    id: 'mock-user-001',
    email: _email,
    name: 'Test User',
  );

  static const _mockTokens = TokensModel(
    accessToken: 'mock-access-token',
    refreshToken: 'mock-refresh-token',
  );

  @override
  Future<({UserModel user, TokensModel tokens})> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);

    if (email != _email || password != _password) {
      throw const UnauthorizedException(
        message: 'Invalid credentials. Use test@gmail.com / passworD@123',
      );
    }

    return (user: _mockUser, tokens: _mockTokens);
  }

  @override
  Future<({UserModel user, TokensModel tokens})> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);

    return (
      user: UserModel(id: 'mock-user-002', email: email, name: name),
      tokens: _mockTokens,
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> verifyOtp({required String email, required String code}) async {
    await Future<void>.delayed(_delay);

    if (code != '123456') {
      throw const ServerException(message: 'Invalid OTP. Use 123456');
    }
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(_delay);
  }
}
