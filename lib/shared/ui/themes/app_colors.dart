// 🎯 Dart imports:
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AppColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF06BC67),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFD9E2),
    onPrimaryContainer: Color(0xFF3E001D),
    secondary: Color(0xFFd9f0bc),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFD9E2),
    onSecondaryContainer: Color(0xFF2B151C),
    tertiary: Color(0xFFab8c5c),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDCC1),
    onTertiaryContainer: Color(0xFF2E1500),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color.fromARGB(255, 246, 246, 241),
    onBackground: Color(0xFF201A1B),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF201A1B),
    surfaceVariant: Color(0xFFF2DDE1),
    onSurfaceVariant: Color(0xFF514347),
    outline: Color(0xFF837377),
    onInverseSurface: Color(0xFFFAEEEF),
    inverseSurface: Color(0xFF352F30),
    inversePrimary: Color(0xFFFFB1C8),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFB90063),
    outlineVariant: Color(0xFFD5C2C6),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB1C8),
    onPrimary: Color(0xFF650033),
    primaryContainer: Color(0xFF8E004A),
    onPrimaryContainer: Color(0xFFFFD9E2),
    secondary: Color(0xFFE3BDC6),
    onSecondary: Color(0xFF422931),
    secondaryContainer: Color(0xFF5A3F47),
    onSecondaryContainer: Color(0xFFFFD9E2),
    tertiary: Color(0xFFEFBD94),
    onTertiary: Color(0xFF48290C),
    tertiaryContainer: Color(0xFF623F20),
    onTertiaryContainer: Color(0xFFFFDCC1),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF201A1B),
    onBackground: Color(0xFFEBE0E1),
    surface: Color(0xFF201A1B),
    onSurface: Color(0xFFEBE0E1),
    surfaceVariant: Color(0xFF514347),
    onSurfaceVariant: Color(0xFFD5C2C6),
    outline: Color(0xFF9E8C90),
    onInverseSurface: Color(0xFF201A1B),
    inverseSurface: Color(0xFFEBE0E1),
    inversePrimary: Color(0xFFB90063),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFFFB1C8),
    outlineVariant: Color(0xFF514347),
    scrim: Color(0xFF000000),
  );

  // NEW
  static const primary = Color(0xFF06BC67);
  static const secondary = Color.fromARGB(255, 114, 177, 38);
  static const tertiary = Color(0xFFab8c5c);
  static const neutral = Color(0xFF91918b);

  //* Basic colors
  // static const primary = Color(0xFF06BC67);
  // static const success = Color(0xFF74C627);
  // static const grenDark = Color(0xFF004735);
  // static const info = Color(0xFF1C68ED);
  // static const danger = Color(0xFFFF3B2D);
  // static const warning = Color(0xFFE8D910);
  // static const lines = Color(0xFFCCCCCC);
  // static const background = Color(0xFFFAFAFA);

  // static const yellow = Color(0xFFF8EF6C);

  //* Grey colors
  // static const greyLight = Color(0xFF9D9D9D);
  // static const grey = Color(0xFF585666);
  // static const greySweet = Color(0xFF544F4F);
  // static const greyDark = Color(0xFF3a3a3b);
  // static const greyBlack = Color(0xFF393939);

  //* Other colors
  // static const delete = Color(0xFFE83F5B);
  static const heading = Color(0xFF585666);
  static const body = Color(0xFF706E7A);
  // static const line = Color(0xFFD1D1D1);
  // static const stroke = Color(0xFFE3E3E6);
  // static const shape = Color(0xFFFAFAFC);
  static const white = Color(0xFFFFFFFF);

  //* Enzymes colors
  static const betaGlucosidase = Color(0xFF721817);
  static const aryl = Color(0xFFFA9F42);
  static const fosfataseAcida = Color(0xFF2B4162);
  static const fosfataseAlcalina = Color(0xFF88AB75);
  static const urease = Color(0xFF675C38);
  static const fda = Color(0xFF92437f);

  /* static MaterialColor materialTheme = const MaterialColor(
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
 */

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
