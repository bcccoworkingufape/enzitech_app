import 'package:flutter/material.dart';

abstract class SaveThemeModeUseCase {
  Future<void> call(ThemeMode theme);
}
