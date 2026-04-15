abstract class ApiEnvironment {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final String? certificateAssetPath;
  final Map<String, String> headers;
  final bool enableLogger;

   ApiEnvironment({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 60),
    this.receiveTimeout = const Duration(seconds: 60),
    this.sendTimeout    = const Duration(seconds: 60),
    this.certificateAssetPath,
    this.headers = const {},
    this.enableLogger = false,
  });
  bool get sslPinningEnabled => certificateAssetPath != null;
}