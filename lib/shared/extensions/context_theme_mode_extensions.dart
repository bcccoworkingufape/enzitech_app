// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../features/main/presentation/viewmodel/settings_viewmodel.dart';
import '../ui/ui.dart';

extension ContextThemeMode on BuildContext {
  bool get isDarkMode {
    ColorScheme applyedColorScheme = getApplyedColorScheme;
    return applyedColorScheme.brightness == Brightness.dark;
  }

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
