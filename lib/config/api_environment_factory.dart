
import 'package:core/core_package.dart';
import 'package:core_implementation/core_implementation.dart';

import 'app_config.dart';
import 'flavor_config.dart';

ApiEnvironment buildApiEnvironmentForCurrentFlavor({
  Map<String, String> commonHeaders = const {},
  Map<String, String> developmentHeaders = const {},
  Map<String, String> stagingHeaders = const {},
  Map<String, String> productionHeaders = const {},
}) {
  return switch (FlavorSetup.current) {
    AppFlavor.development => DevelopmentEnvironment(
      baseUrl:AppConfig.instance.baseUrl,
      headers: {...commonHeaders, ...developmentHeaders},
    ),
    AppFlavor.staging => StagingEnvironment(
      baseUrl:AppConfig.instance.baseUrl,
      headers: {...commonHeaders, ...stagingHeaders},
    ),
    AppFlavor.production => ProductionEnvironment(
      baseUrl:AppConfig.instance.baseUrl,
      headers: {...commonHeaders, ...productionHeaders},
    ),
  };
}