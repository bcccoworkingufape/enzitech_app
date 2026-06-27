import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around `flutter_secure_storage` dedicated to session secrets
/// (auth token). Keystore-backed on Android via EncryptedSharedPreferences,
/// Keychain on iOS.
///
/// Why a dedicated service: the legacy `UserPreferencesService` is bound to
/// SharedPreferences (used for non-sensitive UI prefs). Funnelling session
/// secrets through this isolated service keeps the trust boundary obvious.
class SecureSessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  /// Migrates a legacy token (SharedPreferences-backed) into secure storage.
  /// Idempotent: if no legacy token is provided or storage already has one,
  /// it returns without changes.
  Future<void> migrateFromLegacyIfNeeded({
    required Future<String?> Function() legacyReader,
    Future<void> Function(String)? legacyClearer,
  }) async {
    try {
      final existing = await _storage.read(key: _tokenKey);
      if (existing != null && existing.isNotEmpty) {
        return;
      }
      final legacy = await legacyReader();
      if (legacy == null || legacy.isEmpty) {
        return;
      }
      await _storage.write(key: _tokenKey, value: legacy);
      if (legacyClearer != null) {
        await legacyClearer(legacy);
      }
    } catch (e) {
      // Best-effort: never crash app boot over a migration failure.
      debugPrint('SecureSessionStorage migration skipped: $e');
    }
  }

  Future<void> writeToken(String token) async {
    if (token.isEmpty) {
      await removeToken();
      return;
    }
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }
}
