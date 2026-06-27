// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

import 'screen_protection_service.dart';

/// Adds FLAG_SECURE-equivalent behaviour to a screen.
///
/// `enable` runs in `initState`; `disable` runs in `dispose`. A neutral
/// privacy overlay is shown while the app is paused to avoid leaking the
/// screen via the recents thumbnail.
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

  /// Wrap your screen body with this to apply the privacy overlay when the
  /// app is backgrounded.
  Widget wrapSecureScreen({required Widget child}) {
    return Stack(
      children: [
        child,
        if (_showOverlay)
          const Positioned.fill(
            child: ColoredBox(color: Color(0xFFFAFAFA)),
          ),
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
