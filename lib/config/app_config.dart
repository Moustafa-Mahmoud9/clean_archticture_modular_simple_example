/// Pure configuration container. No logic, no switches, no flavor awareness.
///
/// Constructed once in main_*.dart with values from the flavor-specific
/// Envied class. Accessible everywhere via [AppConfig.instance].
class AppConfig {
  final String baseUrl;
  final String appName;
  final bool showTranslationFeature;
  final double consolateLat;
  final double consolateLng;

  const AppConfig({
    required this.baseUrl,
    required this.appName,
    required this.showTranslationFeature,
    required this.consolateLat,
    required this.consolateLng,
  });

  static late AppConfig instance;
}