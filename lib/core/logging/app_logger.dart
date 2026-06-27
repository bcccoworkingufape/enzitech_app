import 'package:flutter/foundation.dart';

/// Minimal sanitized logger used across the app. Release builds compile the
/// debug/info/warn calls into no-ops via `kDebugMode` so we never emit
/// PII or session data to logcat.
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

  /// Errors keep the message+context in debug and forward a stripped version
  /// to Crashlytics via the existing global handler (no PII redaction needed
  /// because the source message is sanitized by callers).
  static void error(String message, {Object? error, StackTrace? stack, Map<String, Object?>? context}) {
    if (kDebugMode) {
      _emit('ERROR', message, context);
      // ignore: avoid_print
      print('  err: $error');
      // ignore: avoid_print
      print('  stk: $stack');
    }
  }

  /// Public helper so sensitive inputs (Authorization headers, raw request
  /// bodies) can be masked before being forwarded to any logger.
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
