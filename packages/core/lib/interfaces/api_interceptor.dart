

import '../models/http_method.dart';

class RequestDetails {
  final HttpMethod method;
  final String path;
  dynamic data;
  final Map<String, dynamic> headers;
  final Map<String, dynamic> extra;

  RequestDetails({
    required this.method,
    required this.path,
    this.data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  })  : headers = headers ?? <String, dynamic>{},
        extra = extra ?? <String, dynamic>{};
}

/// Data carried through an interceptor on every incoming response.
class ResponseDetails {
  /// Parsed response body.
  final dynamic data;

  /// HTTP status code returned by the server.
  final int? statusCode;

  /// Response headers.
  final Map<String, dynamic> headers;

  ResponseDetails({
    required this.data,
    this.statusCode,
    required this.headers,
  });
}

/// Data carried through an interceptor when any error occurs.
class ErrorDetails {
  /// Human-readable error message (already normalised by ErrorNormalizerInterceptor).
  final String message;

  /// HTTP status code, or null for network/timeout/ssl errors.
  final int? statusCode;

  /// The raw error object from the HTTP library — for advanced inspection only.
  final Object? originalError;

  ErrorDetails({
    required this.message,
    this.statusCode,
    this.originalError,
  });
}


abstract class ApiInterceptor {
  /// Called before the request is sent.
  Future<RequestDetails> onRequest(RequestDetails details);
  Future<ResponseDetails> onResponse(ResponseDetails details);
  Future<ErrorDetails> onError(ErrorDetails details);
}