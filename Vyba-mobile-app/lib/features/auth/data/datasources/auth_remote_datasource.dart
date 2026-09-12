import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/auth/data/models/tokens_model.dart';
import 'package:flutter_templates/features/auth/data/models/user_model.dart';

/// Result of a successful verify or refresh call.
typedef AuthResult = ({UserModel user, TokensModel tokens});

/// Remote data source for the phone-OTP auth API (ADR-0003).
abstract class AuthRemoteDataSource {
  /// POST request (or resend) an OTP code.
  Future<void> requestOtp({required String phoneNumber});

  /// POST verify an OTP code; returns the user and a fresh token pair.
  Future<AuthResult> verifyOtp({
    required String phoneNumber,
    required String code,
    bool? ageConfirmed,
    String? clientId,
  });

  /// POST rotate the access token.
  Future<AuthResult> refresh({required String refreshToken});
}

/// Implementation of [AuthRemoteDataSource] using [Dio].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates an [AuthRemoteDataSourceImpl].
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> requestOtp({required String phoneNumber}) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.requestOtp,
        data: {'phone': phoneNumber},
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<AuthResult> verifyOtp({
    required String phoneNumber,
    required String code,
    bool? ageConfirmed,
    String? clientId,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.verifyOtp,
        data: {
          'phone': phoneNumber,
          'code': code,
          if (ageConfirmed != null) 'ageConfirmed': ageConfirmed,
          if (clientId != null) 'clientId': clientId,
        },
      );
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<AuthResult> refresh({required String refreshToken}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  AuthResult _parseAuthResponse(Map<String, dynamic>? data) {
    if (data == null) {
      throw const ServerException(message: 'Réponse vide du serveur');
    }
    final userData = data['user'];
    if (userData is! Map<String, dynamic>) {
      throw const ServerException(message: 'Données utilisateur invalides');
    }
    return (
      user: UserModel.fromJson(userData),
      tokens: TokensModel.fromJson(data),
    );
  }

  /// Unwraps the typed exception [ErrorInterceptor] attaches to
  /// [DioException.error] and throws it directly, so repository-layer
  /// `on ServerException` / `on UnauthorizedException` catches actually fire
  /// instead of only ever seeing a raw [DioException].
  Never _throwMapped(DioException e) {
    final wrapped = e.error;
    if (wrapped is Exception) throw wrapped;
    throw ServerException(message: e.message ?? 'Erreur réseau');
  }
}
