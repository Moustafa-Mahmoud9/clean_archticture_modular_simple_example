import 'config/app_config.dart';
import 'config/app_env_development.dart';
import 'config/flavor_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.instance = AppConfig(
    baseUrl: AppEnvDevelopment.baseUrl,
    appName: AppEnvDevelopment.appName,
    showTranslationFeature: AppEnvDevelopment.showTranslationFeature,
    consolateLat: AppEnvDevelopment.consolateLat,
    consolateLng: AppEnvDevelopment.consolateLng,
  );

  FlavorSetup.setup(AppFlavor.development);
  app.bootstrap();
}