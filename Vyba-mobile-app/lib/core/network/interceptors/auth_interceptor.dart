import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/core/storage/secure_storage.dart';
import 'package:flutter_templates/core/utils/logger.dart';

/// Attaches the access token to outgoing requests and
/// handles automatic token refresh on 401 responses.
///
/// Uses [QueuedInterceptor] so concurrent requests wait for
/// the token refresh to complete before retrying.
class AuthInterceptor extends QueuedInterceptor {
  /// Creates an [AuthInterceptor].
  AuthInterceptor({
    required SecureStorage secureStorage,
    required Dio dio,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  final SecureStorage _secureStorage;
  final Dio _dio;

  /// Paths that do not require authentication.
  /// Matched via exact equality (not contains) to prevent bypasses.
  static const _publicPaths = [
    ApiEndpoints.requestOtp,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.refreshToken,
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.contains(options.path);
    if (!isPublic) {
      final token = await _secureStorage.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          final retryResponse = await _retryRequest(err.requestOptions);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        AppLogger.error('Token refresh failed', error: e);
      }
      // Refresh failed or token was invalid — clear and propagate.
      await _secureStorage.clearTokens();
    }
    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final data = response.data;
      if (data != null) {
        final newAccess = data['accessToken'] as String?;
        final newRefresh = data['refreshToken'] as String?;
        if (newAccess != null) {
          await _secureStorage.setAccessToken(newAccess);
        }
        if (newRefresh != null) {
          await _secureStorage.setRefreshToken(newRefresh);
        }
        return newAccess != null;
      }
    } on DioException catch (e) {
      AppLogger.error('Refresh token request failed', error: e);
    }
    return false;
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    final token = await _secureStorage.getAccessToken();
    options.headers['Authorization'] = 'Bearer $token';
    return _dio.fetch<dynamic>(options);
  }
}
