// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../features/main/presentation/viewmodel/settings_viewmodel.dart';
import '../ui/ui.dart';

extension ContextThemeMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    ColorScheme applyedColorScheme = getApplyedColorScheme;
    return applyedColorScheme.brightness == Brightness.dark;
    // final brightness = MediaQuery.of(this).platformBrightness;
    // return brightness == Brightness.dark;
  }

  // Brightness get getBrightnessMode {
  //   final brightness = MediaQuery.of(this).platformBrightness;
  //   return brightness;
  // }

  // /// This method check if Light Mode is manually selected or System color is Light
  // bool get isLightMode {
  //   final brightness = MediaQuery.of(this).platformBrightness;
  //   final themeMode = GetIt.I.get<SettingsViewmodel>().themeMode;
  //   return brightness == Brightness.light || themeMode == ThemeMode.light;
  // }

  ColorScheme get getApplyedColorScheme {
    final systemBrightness = MediaQuery.of(this).platformBrightness;
    final choosedAppThemeMode = GetIt.I.get<SettingsViewmodel>().themeMode;

    if (systemBrightness == Brightness.light) {
      if (choosedAppThemeMode == ThemeMode.dark) {
        return AppColors.darkColorScheme;
      }

      return AppColors.lightColorScheme;
    }

    if (choosedAppThemeMode != ThemeMode.light) {
      return AppColors.darkColorScheme;
    }

    return AppColors.lightColorScheme;
  }
}
