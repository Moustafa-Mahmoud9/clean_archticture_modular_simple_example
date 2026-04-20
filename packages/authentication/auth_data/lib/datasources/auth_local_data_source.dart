import 'dart:convert';

import 'package:core_implementation/core_implementation.dart';

import '../models/user_model.dart';
import 'app_token_provider.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(LoginModel user);

  Future<LoginModel> getCachedUser();

  Future<void> cacheToken(String token);

  Future<String?> getCachedToken();

  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storage; // ← was SecureStorageService
  final AppTokenProvider _tokenProvider;

  AuthLocalDataSourceImpl({
    required StorageService storage, // ← was SecureStorageService
    required AppTokenProvider tokenProvider,
  }) : _storage = storage,
       _tokenProvider = tokenProvider;

  // ── User caching ────────────────────────────────────────────────────────────

  @override
  Future<void> cacheUser(LoginModel user) async {
    try {
      await _storage.write(
        key: 'cached_user',
        value: jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: $e');
    }
  }

  @override
  Future<LoginModel> getCachedUser() async {
    try {
      final jsonString = await _storage.read(key: 'cached_user');
      if (jsonString != null) {
        return LoginModel.fromJson(jsonDecode(jsonString));
      }
      throw const CacheException(message: 'No cached user found');
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user: $e');
    }
  }

  // ── Token caching ───────────────────────────────────────────────────────────
  // Token keys now live here — not in SecureStorageService.
  // AppTokenProvider reads these same keys when attaching the Bearer header.

  @override
  Future<void> cacheToken(String token) async {
    try {
      await _tokenProvider.saveAccessToken(token);
    } catch (e) {
      throw CacheException(message: 'Failed to cache token: $e');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return await _tokenProvider.getAccessToken();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached token: $e');
    }
  }

  // ── Clear ───────────────────────────────────────────────────────────────────

  @override
  Future<void> clearCache() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }
}
