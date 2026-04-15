/// Type-safe HTTP method enum.
///
/// Replaces raw String method names like 'GET', 'POST' etc.
/// Implementations convert this to whatever their HTTP library needs.
///
/// Example in DioClient:
/// ```dart
/// options: Options(method: req.method.value),
/// ```
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  /// The raw String value sent in the HTTP request.
  /// Use this when passing to your HTTP library.
  final String value;

  const HttpMethod(this.value);
}