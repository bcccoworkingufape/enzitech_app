// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

import 'screen_protection_service.dart';

/// Adiciona um comportamento equivalente a FLAG_SECURE para uma tela.
///
/// `enable` é executado em `initState`; `disable` é executado em `dispose`. Uma
/// sobreposição neutra de privacidade é exibida enquanto o app está em pausa para
/// evitar o vazamento da tela pela miniatura dos aplicativos recentes.
mixin SecureScreenMixin<T extends StatefulWidget> on State<T> {
  bool _wasEnabled = false;
  bool _showOverlay = false;
  late final _SecureScreenObserver _observer;

  @override
  void initState() {
    super.initState();
    _observer = _SecureScreenObserver(this);
    WidgetsBinding.instance.addObserver(_observer);
    _enableProtection();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_observer);
    _disableProtection();
    super.dispose();
  }

  void _onLifecycle(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        if (!_showOverlay) {
          setState(() => _showOverlay = true);
        }
        break;
      case AppLifecycleState.resumed:
        if (_showOverlay) {
          setState(() => _showOverlay = false);
        }
        _enableProtection();
        break;
      case AppLifecycleState.detached:
        _disableProtection();
        break;
    }
  }

  Future<void> _enableProtection() async {
    final ok = await ScreenProtectionService.enable();
    _wasEnabled = ok;
  }

  Future<void> _disableProtection() async {
    if (!_wasEnabled) return;
    await ScreenProtectionService.disable();
    _wasEnabled = false;
  }

  /// Envolva o corpo da tela com isso para aplicar a sobreposição de privacidade quando o
  /// app for colocado em segundo plano.
  Widget wrapSecureScreen({required Widget child}) {
    return Stack(
      children: [
        child,
        if (_showOverlay) const Positioned.fill(child: ColoredBox(color: Color(0xFFFAFAFA))),
      ],
    );
  }
}

class _SecureScreenObserver with WidgetsBindingObserver {
  _SecureScreenObserver(this._owner);
  final SecureScreenMixin<dynamic> _owner;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _owner._onLifecycle(state);
  }
}
