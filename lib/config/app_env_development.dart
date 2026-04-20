import 'package:envied/envied.dart';

part 'app_env_development.g.dart';

@Envied(path: '.env.development')
abstract class AppEnvDevelopment {
  @EnviedField(varName: 'DEVELOPING_BASE_URL', obfuscate: true)
  static final String baseUrl = _AppEnvDevelopment.baseUrl;

  @EnviedField(varName: 'APP_NAME')
  static final String appName = _AppEnvDevelopment.appName;

  @EnviedField(varName: 'SHOW_TRANSLATION_FEATURE')
  static final bool showTranslationFeature =
      _AppEnvDevelopment.showTranslationFeature;

  @EnviedField(varName: 'CONSLATE_LAT')
  static final double consolateLat = _AppEnvDevelopment.consolateLat;

  @EnviedField(varName: 'CONSLATE_LNG')
  static final double consolateLng = _AppEnvDevelopment.consolateLng;
}