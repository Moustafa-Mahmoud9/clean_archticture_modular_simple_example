import 'secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Concrete [StorageService] implementation using flutter_secure_storage.
///
/// Stores all values encrypted on the device keychain (iOS)
/// or EncryptedSharedPreferences (Android).
///
/// Registration in injection_container.dart:
/// ```dart
/// sl.registerLazySingleton<StorageService>(
///   () => SecureStorageService.defaultInstance(),
/// );
/// ```
class SecureStorageService implements StorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  /// Convenience factory — root app never imports FlutterSecureStorage.
  factory SecureStorageService.defaultInstance() =>
      const SecureStorageService(FlutterSecureStorage());

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<bool> containsKey({required String key}) =>
      _storage.containsKey(key: key);
}