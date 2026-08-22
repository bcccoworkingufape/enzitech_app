// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 🌎 Project imports:
import '../../../logging/app_logger.dart';

/// Wrapper em torno do `flutter_secure_storage` dedicado a segredos de sessão
/// (token de autenticação). Com suporte a Keystore no Android via EncryptedSharedPreferences,
/// Keychain no iOS.
///
/// Por que um serviço dedicado: o `UserPreferencesService` legado é vinculado ao
/// SharedPreferences (usado para preferências de UI não sensíveis). Canalizar os
/// segredos de sessão por este serviço isolado mantém a fronteira de confiança explícita.
class SecureSessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
          );

  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  /// Migra um token legado (baseado em SharedPreferences) para o armazenamento seguro.
  /// Idempotente: se nenhum token legado for fornecido ou se o armazenamento já tiver um,
  /// retorna sem alterações.
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
      // Melhor esforço: nunca derrubar a inicialização do app por falha na migração.
      AppLogger.warn('SecureSessionStorage migration skipped');
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
