import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';

/// Maps [DioException] types to application-specific exceptions.
///
/// Stores typed exceptions in [DioException.error] via [handler.reject]
/// instead of throwing, so the interceptor chain continues and
/// [AuthInterceptor] can handle 401s for token refresh.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException(
              message: 'Connection timed out. Please check your network.',
            ),
            type: err.type,
          ),
        );
      case DioExceptionType.badResponse:
        _handleBadResponse(err, handler);
      case DioExceptionType.cancel:
        handler.next(err);
      case DioExceptionType.badCertificate:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const ServerException(message: 'Invalid SSL certificate'),
            type: err.type,
          ),
        );
      case DioExceptionType.unknown:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException(
              message: 'An unexpected network error occurred.',
            ),
            type: err.type,
          ),
        );
    }
  }

  void _handleBadResponse(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    final message = data is Map<String, dynamic>
        ? (data['message'] as String?) ?? 'Server error'
        : 'Server error';

    if (statusCode == null) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: ServerException(message: message),
          type: err.type,
        ),
      );
      return;
    }

    final Exception exception = switch (statusCode) {
      401 => UnauthorizedException(message: message),
      403 => UnauthorizedException(message: 'Access forbidden: $message'),
      404 => ServerException(message: 'Not found: $message', statusCode: 404),
      422 => ServerException(
          message: 'Validation error: $message',
          statusCode: 422,
        ),
      >= 500 => ServerException(message: message, statusCode: statusCode),
      _ => ServerException(message: message, statusCode: statusCode),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: exception,
        type: err.type,
      ),
    );
  }
}
