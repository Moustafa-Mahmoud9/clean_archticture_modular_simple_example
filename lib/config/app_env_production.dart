import 'package:envied/envied.dart';

part 'app_env_production.g.dart';

@Envied(path: '.env.production')
abstract class AppEnvProduction {
  @EnviedField(varName: 'PRODUCTION_BASE_URL', obfuscate: true)
  static final String baseUrl = _AppEnvProduction.baseUrl;

  @EnviedField(varName: 'APP_NAME')
  static final String appName = _AppEnvProduction.appName;

  @EnviedField(varName: 'SHOW_TRANSLATION_FEATURE')
  static final bool showTranslationFeature =
      _AppEnvProduction.showTranslationFeature;

  @EnviedField(varName: 'CONSLATE_LAT')
  static final double consolateLat = _AppEnvProduction.consolateLat;

  @EnviedField(varName: 'CONSLATE_LNG')
  static final double consolateLng = _AppEnvProduction.consolateLng;
}