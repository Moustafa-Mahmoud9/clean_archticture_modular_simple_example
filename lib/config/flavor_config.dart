import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

enum AppFlavor {development,staging, production}

class FlavorSetup {
  static AppFlavor? _cached;

  static AppFlavor get current {
    if (_cached != null) return _cached!;

    final name = FlavorConfig.instance.name;
    _cached = switch (name) {
      'development' => AppFlavor.development,
      'staging' => AppFlavor.staging,
      'production' => AppFlavor.production,
      _ => throw StateError(
        'Unknown flavor: "$name". Call FlavorSetup.setup() before runApp.',
      ),
    };
    return _cached!;
  }

  static void setup(AppFlavor flavor) {
    _cached = flavor;
    FlavorConfig(
      name: flavor.name,
      color: switch (flavor) {
        AppFlavor.development => const Color(0xFF4CAF50),
        AppFlavor.staging => const Color(0xFFFFC107),
        AppFlavor.production => const Color(0xFF2196F3),
      },
      location: BannerLocation.topStart,
      variables: {
        'showBanner': flavor != AppFlavor.production,
      },
    );
  }
}