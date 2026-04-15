
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:core/core_package.dart';
/// Concrete [NetworkInfo] implementation using internet_connection_checker.
///
/// Registration in injection_container.dart:
/// ```dart
/// sl.registerLazySingleton<NetworkInfo>(
///   () => NetworkInfoImpl.defaultInstance(),
/// );
/// ```
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _checker;

  NetworkInfoImpl(this._checker);

  /// Convenience factory — root app never imports InternetConnectionChecker.
  factory NetworkInfoImpl.defaultInstance() =>
      NetworkInfoImpl(InternetConnectionChecker());

  @override
  Future<bool> get isConnected => _checker.hasConnection;

  @override
  Stream<bool> get onConnectivityChanged => _checker.onStatusChange.map(
        (status) => status == InternetConnectionStatus.connected,
  );
}