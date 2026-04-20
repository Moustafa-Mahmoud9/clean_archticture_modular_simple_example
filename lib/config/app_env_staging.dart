import 'package:envied/envied.dart';

part 'app_env_staging.g.dart';

@Envied(path: '.env.staging')
abstract class AppEnvStaging {
  @EnviedField(varName: 'STAGING_BASE_URL', obfuscate: true)
  static final String baseUrl = _AppEnvStaging.baseUrl;

  @EnviedField(varName: 'APP_NAME')
  static final String appName = _AppEnvStaging.appName;

  @EnviedField(varName: 'SHOW_TRANSLATION_FEATURE')
  static final bool showTranslationFeature =
      _AppEnvStaging.showTranslationFeature;

  @EnviedField(varName: 'CONSLATE_LAT')
  static final double consolateLat = _AppEnvStaging.consolateLat;

  @EnviedField(varName: 'CONSLATE_LNG')
  static final double consolateLng = _AppEnvStaging.consolateLng;
}