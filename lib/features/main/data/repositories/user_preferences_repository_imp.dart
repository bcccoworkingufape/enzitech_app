// ðŸ¦ Flutter imports:
import 'package:flutter/material.dart';

// ðŸ“¦ Package imports:
import 'package:dartz/dartz.dart';

// ðŸŒŽ Project imports:
import '../../../../core/failures/failure.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../datasources/user_preferences_datasource.dart';

class UserPreferencesRepositoryImp implements UserPreferencesRepository {
  final UserPreferencesDataSource _userPreferencesDataSource;

  UserPreferencesRepositoryImp(this._userPreferencesDataSource);

  @override
  Future<void> clearUser() async {
    await _userPreferencesDataSource.clearUser();
  }

  @override
  Future<Either<Failure, bool>> getExcludeConfirmation() async {
    return await _userPreferencesDataSource.getExcludeConfirmation();
  }

  @override
  Future<Either<Failure, bool>> getReplaceLanguage() async {
    return await _userPreferencesDataSource.getReplaceLanguage();
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    var result = await _userPreferencesDataSource.getThemeMode();

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

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    return await _userPreferencesDataSource.getUser();
  }

  @override
  Future<void> saveExcludeConfirmation(bool value) async {
    return await _userPreferencesDataSource.saveExcludeConfirmation(value);
  }

  @override
  Future<void> saveReplaceLanguage(bool value) async {
    return await _userPreferencesDataSource.saveReplaceLanguage(value);
  }

  @override
  Future<void> saveThemeMode(ThemeMode theme) async {
    String themeAsString = theme.toString().split('.').last.toLowerCase();

    return await _userPreferencesDataSource.saveThemeMode(themeAsString);
  }
}


