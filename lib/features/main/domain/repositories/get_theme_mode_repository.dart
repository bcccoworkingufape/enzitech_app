// 📦 Package imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:

abstract class GetThemeModeRepository {
  Future<ThemeMode> call();
}
