// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../repositories/get_theme_mode_repository.dart';
import 'get_theme_mode_usecase.dart';

class GetThemeModeUseCaseImp implements GetThemeModeUseCase {
  final GetThemeModeRepository _getThemeModeRepository;

  GetThemeModeUseCaseImp(this._getThemeModeRepository);

  @override
  Future<ThemeMode> call() async {
    return await _getThemeModeRepository();
  }
}
