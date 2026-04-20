import 'config/app_config.dart';
import 'config/app_env_production.dart';
import 'config/flavor_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.instance = AppConfig(
    baseUrl: AppEnvProduction.baseUrl,
    appName: AppEnvProduction.appName,
    showTranslationFeature: AppEnvProduction.showTranslationFeature,
    consolateLat: AppEnvProduction.consolateLat,
    consolateLng: AppEnvProduction.consolateLng,
  );

  FlavorSetup.setup(AppFlavor.production);
  app.bootstrap();
}