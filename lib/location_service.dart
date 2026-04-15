// lib/services/location_service.dart

import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? _lastKnownPosition;

  /// Fire this without await in initDependencies().
  /// It runs in the background and caches the position when ready.
  Future<void> initialize() async {
    LocationPermission permission = await Geolocator.checkPermission();

    // Request if denied — reassign so we use the updated status below
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // Cannot request again — user must go to device settings
    if (permission == LocationPermission.deniedForever) return;

    // GPS hardware might be toggled off even if permission is granted
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    try {
      // Low accuracy = faster fix at startup
      _lastKnownPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 5));
    } catch (_) {
      // Timeout or error — fall back to last known position from device
      _lastKnownPosition = await Geolocator.getLastKnownPosition();
    }
  }

  /// Returns null safely if location is not yet available or was denied.
  Future<Map<String, double>?> getLocation() async {
    if (_lastKnownPosition == null) return null;
    return {
      'latitude':  _lastKnownPosition!.latitude,
      'longitude': _lastKnownPosition!.longitude,
    };
  }
}