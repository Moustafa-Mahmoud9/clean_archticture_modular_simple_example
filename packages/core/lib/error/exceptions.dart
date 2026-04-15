/// Thrown when the remote server returns an error response (4xx / 5xx).
class ServerException implements Exception {
  final String message;
  final int statusCode;

  const ServerException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

/// Thrown when reading from or writing to local cache fails.
class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}

/// Thrown when there is no internet connection.
class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException(message: $message)';
}

/// Thrown when a request or response exceeds the allowed time.
class TimeoutException implements Exception {
  final String message;

  const TimeoutException({required this.message});

  @override
  String toString() => 'TimeoutException(message: $message)';
}

/// Thrown when the server returns 401 Unauthorized.
class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({required this.message});

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}

/// Thrown when the response body cannot be parsed.
class ParseException implements Exception {
  final String message;

  const ParseException({required this.message});

  @override
  String toString() => 'ParseException(message: $message)';
}