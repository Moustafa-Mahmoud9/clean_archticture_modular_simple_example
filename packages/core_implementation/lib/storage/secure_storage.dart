abstract class StorageService {
  /// Persists [value] under [key]. Overwrites if key already exists.
  Future<void> write({required String key, required String value});

  /// Returns the value stored under [key], or null if not found.
  Future<String?> read({required String key});

  /// Returns all stored key-value pairs.
  Future<Map<String, String>> readAll();

  /// Removes the entry for [key]. No-op if key does not exist.
  Future<void> delete({required String key});

  /// Removes every entry from storage.
  Future<void> deleteAll();

  /// Returns true if [key] exists in storage.
  Future<bool> containsKey({required String key});
}