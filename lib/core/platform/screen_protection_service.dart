// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Thin Dart wrapper that calls the platform's secure-window API.
///
/// On Android we invoke `WindowManager#addFlags(FLAG_SECURE)` via the
/// `flutter_windowmanager` plugin (added as a dependency). On other
/// platforms the call is a no-op so the same code compiles everywhere.
class ScreenProtectionService {
  ScreenProtectionService._();

  static const _channel = MethodChannel('enzitech/screen_protection');

  /// Enables the platform secure-window flag. Returns the platform status;
  /// callers can decide whether to log a soft warning.
  static Future<bool> enable() async {
    if (kIsWeb) return false;
    try {
      // The plugin exposes the method channel under the hood. We invoke the
      // platform channel directly so we can degrade gracefully when the
      // plugin is unavailable (e.g. unit tests, unsupported OS).
      await _channel.invokeMethod<void>('enableSecure');
      return true;
    } catch (e) {
      // Surface the failure only in debug to avoid leaking in release logs.
      if (kDebugMode) {
        // ignore: avoid_print
        print('ScreenProtectionService.enable failed: $e');
      }
      return false;
    }
  }

  static Future<bool> disable() async {
    if (kIsWeb) return false;
    try {
      await _channel.invokeMethod<void>('disableSecure');
      return true;
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('ScreenProtectionService.disable failed: $e');
      }
      return false;
    }
  }
}
