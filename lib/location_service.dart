import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? _lastKnownPosition;
  Future<void>? _initFuture; // ensures initialize() runs only once

  /// Idempotent — safe to call multiple times. The actual init runs once.
  Future<void> initialize() {
    return _initFuture ??= _doInitialize();
  }

  Future<void> _doInitialize() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      try {
        _lastKnownPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        ).timeout(const Duration(seconds: 5));
      } catch (_) {
        _lastKnownPosition = await Geolocator.getLastKnownPosition();
      }
    } catch (e) {
      // Catches MissingPluginException and any other plugin/platform errors
      // so they never bubble up and crash app startup.
      // ignore: avoid_print
      print('LocationService init failed: $e');
    }
  }

  /// Returns null safely if location is not yet available or was denied.
  /// Triggers initialization on first call if it hasn't happened yet.
  Future<Map<String, double>?> getLocation() async {
    await initialize(); // safe — runs once, returns cached future after that
    if (_lastKnownPosition == null) return null;
    return {
      'latitude': _lastKnownPosition!.latitude,
      'longitude': _lastKnownPosition!.longitude,
    };
  }
}