// lib/config/app_env.dart

import 'app_env_development.dart';
import 'app_env_production.dart';
import 'app_env_staging.dart';
import 'flavor_config.dart';

/// Flavor-aware facade over the three generated env classes.
///
/// Call sites read `AppEnv.baseUrl` without knowing which flavor is active.
/// Internally dispatches to the right generated class based on
/// [FlavorSetup.current].
class AppEnv {
  AppEnv._();
  static String get baseUrl {
    return switch (FlavorSetup.current) {
      AppFlavor.development => AppEnvDevelopment.baseUrl,
      AppFlavor.staging => AppEnvStaging.baseUrl,
      AppFlavor.production => AppEnvProduction.baseUrl,
    };
  }

  static String get appName {
    return switch (FlavorSetup.current) {
      AppFlavor.development => AppEnvDevelopment.appName,
      AppFlavor.staging => AppEnvStaging.appName,
      AppFlavor.production => AppEnvProduction.appName,
    };
  }


  static bool get showTranslationFeature {
    return switch (FlavorSetup.current) {
      AppFlavor.development => AppEnvDevelopment.showTranslationFeature,
      AppFlavor.staging => AppEnvStaging.showTranslationFeature,
      AppFlavor.production => AppEnvProduction.showTranslationFeature,
    };
  }

  static double get consolateLat {
    return switch (FlavorSetup.current) {
      AppFlavor.development => AppEnvDevelopment.consolateLat,
      AppFlavor.staging => AppEnvStaging.consolateLat,
      AppFlavor.production => AppEnvProduction.consolateLat,
    };
  }

  static double get consolateLng {
    return switch (FlavorSetup.current) {
      AppFlavor.development => AppEnvDevelopment.consolateLng,
      AppFlavor.staging => AppEnvStaging.consolateLng,
      AppFlavor.production => AppEnvProduction.consolateLng,
    };
  }
}