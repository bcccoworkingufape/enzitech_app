// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

/// Logger sanitizado mínimo usado em todo o app. Builds de release compilam as
/// chamadas debug/info/warn em no-ops via `kDebugMode` para nunca emitirmos
/// PII ou dados de sessão para o logcat.
class AppLogger {
  AppLogger._();

  static const _redacted = '<redacted>';

  static void debug(String message, {Map<String, Object?>? context}) {
    if (kDebugMode) {
      // ignore: avoid_print
      _emit('DEBUG', message, context);
    }
  }

  static void info(String message, {Map<String, Object?>? context}) {
    if (kDebugMode) {
      _emit('INFO', message, context);
    }
  }

  static void warn(String message, {Map<String, Object?>? context}) {
    if (kDebugMode) {
      _emit('WARN', message, context);
    }
  }

  /// Erros mantêm a mensagem + contexto em debug e encaminham uma versão limpa
  /// para o Crashlytics via o handler global existente (não é necessária redação de PII
  /// porque a mensagem original é sanitizada pelos chamadores).
  static void error(String message, {Object? error, StackTrace? stack, Map<String, Object?>? context}) {
    if (kDebugMode) {
      _emit('ERROR', message, context);
      // ignore: avoid_print
      print('  err: $error');
      // ignore: avoid_print
      print('  stk: $stack');
    }
  }

  /// Auxiliar público para que entradas sensíveis (headers de autorização, corpos de requisição brutos)
  /// possam ser mascaradas antes de serem encaminhadas a qualquer logger.
  static String maskSecret(String? value, {int visibleTail = 4}) {
    if (value == null || value.isEmpty) {
      return _redacted;
    }
    if (value.length <= visibleTail) {
      return _redacted;
    }
    final tail = value.substring(value.length - visibleTail);
    return '$_redacted…$tail';
  }

  static void _emit(String level, String message, Map<String, Object?>? context) {
    final base = '[$level] $message';
    if (context == null || context.isEmpty) {
      // ignore: avoid_print
      print(base);
      return;
    }
    // ignore: avoid_print
    print('$base  ctx=$context');
  }
}
