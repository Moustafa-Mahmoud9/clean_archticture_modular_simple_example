import '../models/http_method.dart';

/// Contract that every feature endpoint class must satisfy.
///
/// Each feature creates one class implementing this interface.
/// Instances are built via factory constructors — one per endpoint.
///
/// Usage:
/// ```dart
/// final endpoint = AuthEndpoints.login(accessToken: token);
///
/// await apiClient.request(
///   endpoint.path,
///   method:          endpoint.method,
///   data:            endpoint.body,
///   queryParameters: endpoint.queryParameters,
/// );
/// ```
abstract interface class EndpointProvider {
  /// Path relative to base URL — e.g. '/auth/login'.
  String get path;

  /// HTTP method for this endpoint.
  HttpMethod get method;

  /// URL query parameters — appended as ?key=value.
  Map<String, dynamic>? get queryParameters;

  /// JSON-serializable request body.
  Map<String, dynamic>? get body;

  /// Per-request headers merged on top of base headers.
  /// Auth tokens belong in AuthInterceptor, not here.
  Map<String, String>? get extraHeaders;
}