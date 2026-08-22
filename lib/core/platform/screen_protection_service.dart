// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import '../logging/app_logger.dart';

/// Wrapper fino em Dart que chama a API de janela segura da plataforma.
///
/// No Android, invocamos `WindowManager#addFlags(FLAG_SECURE)` por meio do plugin
/// `flutter_windowmanager` (adicionado como dependência). Em outras plataformas,
/// a chamada é um no-op, então o mesmo código compila em todos os lugares.
class ScreenProtectionService {
  ScreenProtectionService._();

  static const _channel = MethodChannel('enzitech/screen_protection');

  /// Habilita o flag de janela segura da plataforma. Retorna o status da plataforma;
  /// os chamadores podem decidir se registram um aviso leve.
  static Future<bool> enable() async {
    if (kIsWeb) return false;
    try {
      // O plugin expõe o canal de método internamente. Invocamos o
      // canal da plataforma diretamente para degradar graciosamente quando o
      // plugin estiver indisponível (por exemplo, testes unitários, SO sem suporte).
      await _channel.invokeMethod<void>('enableSecure');
      return true;
    } catch (_) {
      AppLogger.warn('ScreenProtectionService.enable failed');
      return false;
    }
  }

  static Future<bool> disable() async {
    if (kIsWeb) return false;
    try {
      await _channel.invokeMethod<void>('disableSecure');
      return true;
    } catch (_) {
      AppLogger.warn('ScreenProtectionService.disable failed');
      return false;
    }
  }
}
