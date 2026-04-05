import 'package:dio/dio.dart';
import 'package:flutter_templates/core/config/env.dart';
import 'package:flutter_templates/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_templates/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_templates/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_templates/core/storage/secure_storage.dart';

/// Factory for creating a configured [Dio] instance.
///
/// Sets up base options from [Env] and attaches all interceptors.
class DioClient {
  const DioClient._();

  /// Creates a [Dio] instance configured for the given [env].
  static Dio create({
    required Env env,
    required SecureStorage secureStorage,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: env.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Order matters: AuthInterceptor (QueuedInterceptor) handles 401
    // token refresh before ErrorInterceptor maps errors to exceptions.
    // LoggingInterceptor goes first for visibility.
    dio.interceptors.addAll([
      if (env.enableLogging) LoggingInterceptor(),
      AuthInterceptor(secureStorage: secureStorage, dio: dio),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
