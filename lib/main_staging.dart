import 'config/app_config.dart';
import 'config/app_env_staging.dart';
import 'config/flavor_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.instance = AppConfig(
    baseUrl: AppEnvStaging.baseUrl,
    appName: AppEnvStaging.appName,
    showTranslationFeature: AppEnvStaging.showTranslationFeature,
    consolateLat: AppEnvStaging.consolateLat,
    consolateLng: AppEnvStaging.consolateLng,
  );

  FlavorSetup.setup(AppFlavor.staging);
  app.bootstrap();
}