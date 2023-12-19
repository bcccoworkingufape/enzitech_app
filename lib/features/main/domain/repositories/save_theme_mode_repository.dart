import 'package:flutter/material.dart';

abstract class SaveThemeModeRepository {
  Future<void> call(ThemeMode theme);
}
