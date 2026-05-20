import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around [FlutterSecureStorage] for sensitive data (tokens).
///
/// Provides typed access to encrypted key-value storage.
class SecureStorage {
  /// Creates a [SecureStorage] with the given [storage] instance.
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  /// Reads the stored access token.
  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  /// Persists the [token] as the access token.
  Future<void> setAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  /// Reads the stored refresh token.
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  /// Persists the [token] as the refresh token.
  Future<void> setRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  /// Removes all stored tokens.
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  /// Reads a custom [key] from secure storage.
  Future<String?> read(String key) => _storage.read(key: key);

  /// Writes a custom [key]-[value] pair to secure storage.
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  /// Deletes a custom [key] from secure storage.
  Future<void> delete(String key) => _storage.delete(key: key);

  /// Clears all data from secure storage.
  Future<void> clearAll() => _storage.deleteAll();
}
