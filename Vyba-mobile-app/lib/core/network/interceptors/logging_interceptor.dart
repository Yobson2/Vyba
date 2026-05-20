import 'package:dio/dio.dart';
import 'package:flutter_templates/core/utils/logger.dart';

/// Logs HTTP requests and responses for debugging.
///
/// Only active when logging is enabled (controlled by [Env]).
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      '--> ${options.method} ${options.uri}',
      tag: 'HTTP',
    );
    if (options.data != null) {
      AppLogger.debug('Body: ${options.data}', tag: 'HTTP');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.info(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
      tag: 'HTTP',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
      tag: 'HTTP',
      error: err.message,
    );
    handler.next(err);
  }
}
