// 📦 Package imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../domain/repositories/get_theme_mode_repository.dart';
import '../datasources/get_theme_mode_datasource.dart';

class GetThemeModeRepositoryImp implements GetThemeModeRepository {
  final GetThemeModeDataSource _getThemeModeDataSource;

  GetThemeModeRepositoryImp(this._getThemeModeDataSource);

  @override
  Future<ThemeMode> call() async {
    var result = await _getThemeModeDataSource();

    return result.fold(
      (error) {
        return ThemeMode.light;
      },
      (success) async {
        switch (success) {
          case 'dark':
            return ThemeMode.dark;
          case 'system':
            return ThemeMode.system;
          default:
            return ThemeMode.light;
        }
      },
    );
  }
}
