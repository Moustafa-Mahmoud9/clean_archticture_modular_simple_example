
abstract class NetworkInfo {
  /// One-shot connectivity check.
  /// Returns true if the device currently has internet access.
  Future<bool> get isConnected;

  /// Stream that emits true when the device comes online
  /// and false when it goes offline.
  /// Use to reactively show/hide a "No Internet" banner.
  Stream<bool> get onConnectivityChanged;
}