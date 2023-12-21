import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../../features/main/presentation/viewmodel/settings_viewmodel.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }

  Brightness get getBrightnessMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness;
  }

  bool get isLightModeOrSystemisLightBrightness {
    final brightness = MediaQuery.of(this).platformBrightness;
    final themeMode = GetIt.I.get<SettingsViewmodel>().themeMode;
    return brightness == Brightness.light || themeMode == ThemeMode.light;
  }
}
