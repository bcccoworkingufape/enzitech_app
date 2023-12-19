// 🌎 Project imports:
import 'package:flutter/material.dart';

import '../../domain/repositories/save_theme_mode_repository.dart';
import '../datasources/save_theme_mode_datasource.dart';

class SaveThemeModeRepositoryImp implements SaveThemeModeRepository {
  final SaveThemeModeDataSource _saveThemeModeDataSource;

  SaveThemeModeRepositoryImp(this._saveThemeModeDataSource);

  @override
  Future<void> call(ThemeMode theme) async {
    String themeAsString = theme.toString().split('.').last.toLowerCase();

    return await _saveThemeModeDataSource(themeAsString);
  }
}
