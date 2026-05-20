import 'dart:convert';

import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/storage/local_storage.dart';
import 'package:flutter_templates/core/storage/secure_storage.dart';
import 'package:flutter_templates/features/auth/data/models/tokens_model.dart';
import 'package:flutter_templates/features/auth/data/models/user_model.dart';

/// Local data source for caching auth data.
abstract class AuthLocalDataSource {
  /// Caches the user profile.
  Future<void> cacheUser(UserModel user);

  /// Gets the cached user profile.
  Future<UserModel> getCachedUser();

  /// Caches authentication tokens.
  Future<void> cacheTokens(TokensModel tokens);

  /// Whether a valid access token exists.
  Future<bool> hasToken();

  /// Clears all cached auth data.
  Future<void> clearAll();
}

/// Implementation of [AuthLocalDataSource].
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// Creates an [AuthLocalDataSourceImpl].
  const AuthLocalDataSourceImpl({
    required SecureStorage secureStorage,
    required LocalStorage localStorage,
  })  : _secureStorage = secureStorage,
        _localStorage = localStorage;

  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;

  static const _cachedUserKey = 'cached_user';

  @override
  Future<void> cacheUser(UserModel user) async {
    final jsonString = json.encode(user.toJson());
    await _localStorage.setString(_cachedUserKey, jsonString);
  }

  @override
  Future<UserModel> getCachedUser() async {
    final jsonString = _localStorage.getString(_cachedUserKey);
    if (jsonString == null) {
      throw const CacheException(message: 'No cached user found');
    }
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return UserModel.fromJson(jsonMap);
  }

  @override
  Future<void> cacheTokens(TokensModel tokens) async {
    await _secureStorage.setAccessToken(tokens.accessToken);
    await _secureStorage.setRefreshToken(tokens.refreshToken);
  }

  @override
  Future<bool> hasToken() async {
    final token = await _secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.clearTokens();
    await _localStorage.remove(_cachedUserKey);
  }
}
