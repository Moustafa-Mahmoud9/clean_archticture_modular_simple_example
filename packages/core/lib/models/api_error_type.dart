enum ApiErrorType {
  /// No internet connection.
  network,

  /// Request or response timed out.
  timeout,

  /// Server returned HTTP 401 Unauthorized.
  unauthorized,

  /// Server returned HTTP 403 Forbidden.
  forbidden,

  /// Server returned HTTP 5xx.
  server,

  /// Server returned HTTP 4xx (other than 401/403).
  client,

  /// SSL handshake or certificate-pinning failure.
  ssl,

  /// Response body could not be parsed into the expected type.
  parse,

  cancelled,
  /// Any other unclassified error.
  unknown,
}