// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../repositories/save_theme_mode_repository.dart';
import 'save_theme_mode_usecase.dart';

class SaveThemeModeUseCaseImp implements SaveThemeModeUseCase {
  final SaveThemeModeRepository _saveThemeModeRepository;

  SaveThemeModeUseCaseImp(this._saveThemeModeRepository);

  @override
  Future<void> call(ThemeMode theme) async {
    return await _saveThemeModeRepository(theme);
  }
}
