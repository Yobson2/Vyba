// coverage:ignore-file

import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/storage/local_storage.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_templates/features/auth/data/models/tokens_model.dart';
import 'package:flutter_templates/features/auth/data/models/user_model.dart';

/// Mock implementation of [AuthRemoteDataSource] for local testing.
///
/// Any phone number + OTP code `123456` succeeds.
///
/// Set `USE_MOCK_AUTH=false` in `.env` to switch to the real API.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  MockAuthRemoteDataSource({required LocalStorage localStorage})
      : _localStorage = localStorage;

  final LocalStorage _localStorage;

  static const _delay = Duration(milliseconds: 800);

  /// Reads the role the user selected on the role-selection page.
  UserRole _savedRole() {
    final roleStr = _localStorage.getString('user_role');
    if (roleStr == null) return UserRole.client;
    return UserRole.values.firstWhere(
      (r) => r.name == roleStr,
      orElse: () => UserRole.client,
    );
  }

  static const _mockTokens = TokensModel(
    accessToken: 'mock-access-token',
    refreshToken: 'mock-refresh-token',
  );

  @override
  Future<void> requestOtp({required String phoneNumber}) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<AuthResult> verifyOtp({
    required String phoneNumber,
    required String code,
    bool? ageConfirmed,
    String? clientId,
  }) async {
    await Future<void>.delayed(_delay);

    if (code != '123456') {
      throw const ServerException(message: 'Code invalide. Utilisez 123456.');
    }

    return (
      user: UserModel(
        id: 'mock-user-phone',
        phone: phoneNumber,
        role: _savedRole(),
      ),
      tokens: _mockTokens,
    );
  }

  @override
  Future<AuthResult> refresh({required String refreshToken}) async {
    await Future<void>.delayed(_delay);
    return (
      user: UserModel(
        id: 'mock-user-phone',
        phone: '+2250000000000',
        role: _savedRole(),
      ),
      tokens: _mockTokens,
    );
  }
}
