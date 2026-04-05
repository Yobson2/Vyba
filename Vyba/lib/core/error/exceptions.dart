/// Exception classes thrown in the data layer.
///
/// These are caught in repository implementations and
/// mapped to corresponding [Failure] types.

/// Exception thrown when a server request fails.
class ServerException implements Exception {
  /// Creates a [ServerException].
  const ServerException({this.message = 'Server error', this.statusCode});

  /// Error message from the server.
  final String message;

  /// HTTP status code.
  final int? statusCode;

  @override
  String toString() =>
      'ServerException(message: $message, statusCode: $statusCode)';
}

/// Exception thrown when a cache operation fails.
class CacheException implements Exception {
  /// Creates a [CacheException].
  const CacheException({this.message = 'Cache error'});

  /// Error message.
  final String message;

  @override
  String toString() => 'CacheException(message: $message)';
}

/// Exception thrown when there is no network connectivity.
class NetworkException implements Exception {
  /// Creates a [NetworkException].
  const NetworkException({this.message = 'No internet connection'});

  /// Error message.
  final String message;

  @override
  String toString() => 'NetworkException(message: $message)';
}

/// Exception thrown when a sync operation fails.
class SyncException implements Exception {
  /// Creates a [SyncException].
  const SyncException({this.message = 'Sync error', this.isConflict = false});

  /// Error message.
  final String message;

  /// Whether this is a conflict (409) that requires resolution.
  final bool isConflict;

  @override
  String toString() =>
      'SyncException(message: $message, isConflict: $isConflict)';
}

/// Exception thrown for unauthorized access (401/403).
class UnauthorizedException implements Exception {
  /// Creates an [UnauthorizedException].
  const UnauthorizedException({this.message = 'Unauthorized'});

  /// Error message.
  final String message;

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}
