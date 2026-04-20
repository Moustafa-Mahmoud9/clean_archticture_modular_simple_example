import 'config/flavor_config.dart';
import 'main.dart' as app;

void main() async {
  FlavorSetup.setup(AppFlavor.development);
  app.bootstrap();
}
