// 🎯 Dart imports:
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF06BC67);
  static const success = Color(0xFF74C627);
  static const info = Color(0xFF1C68ED);
  static const danger = Color(0xFFFF3B2D);
  static const warning = Color(0xFFE8D910);

  static const grey = Color(0xFF585666);
  static const delete = Color(0xFFE83F5B);
  static const heading = Color(0xFF585666);
  static const body = Color(0xFF706E7A);
  static const stroke = Color(0xFFE3E3E6);
  static const shape = Color(0xFFFAFAFC);
  static const background = Color(0xFFFFFFFF);

  static MaterialColor materialTheme = const MaterialColor(
    0xFF06BC67, //primary
    {
      50: Color(0xff76daab),
      100: Color(0xff6ad7a4),
      200: Color(0xff51d095),
      300: Color(0xff38c985),
      400: Color(0xff1fc376),
      500: Color(0xff06bc67),
      600: Color(0xff05a95d),
      700: Color(0xff059652),
      800: Color(0xff048448),
      900: Color(0xff04713e)
    },
  );

  /// Generates material color
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    log(swatch.toString());

    return MaterialColor(color.value, swatch);
  }
}
