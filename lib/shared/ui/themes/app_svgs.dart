import 'package:flutter/material.dart';

import '../../extensions/context_theme_mode_extensions.dart';

class AppSvgs {
  BuildContext context;

  AppSvgs(this.context);

  String error() => context.isDarkMode
      ? "assets/svgs/dark/error.svg"
      : "assets/svgs/light/error.svg";
  String fullLogo() => context.isDarkMode
      ? "assets/svgs/dark/full_logo.svg"
      : "assets/svgs/light/full_logo.svg";
  String iconLogo() => "assets/svgs/icon_logo.svg";
  String developedBy() => context.isDarkMode
      ? "assets/svgs/dark/developed_by.svg"
      : "assets/svgs/light/developed_by.svg";
  String notFound() => context.isDarkMode
      ? "assets/svgs/dark/not_found.svg"
      : "assets/svgs/light/not_found.svg";
  String splash() => context.isDarkMode
      ? "assets/svgs/dark/splash.svg"
      : "assets/svgs/light/splash.svg";
  String logo() => "assets/svgs/logo.svg";
}
