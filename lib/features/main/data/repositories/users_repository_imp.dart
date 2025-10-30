// 🌎 Project imports:
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/failures/failure.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_datasource.dart';

class UsersRepositoryImp implements UsersRepository {
  final UsersDataSource _usersDataSource;

  UsersRepositoryImp(this._usersDataSource);

  @override
  void clearUser() async {
    return _usersDataSource.clearUser();
  }

  @override
  Future<Either<Failure, bool>> getExcludeConfirmation() async {
    return await _usersDataSource.getExcludeConfirmation();
  }

  @override
  Future<Either<Failure, bool>> getReplaceLanguage() async {
    return await _usersDataSource.getReplaceLanguage();
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    var result = await _usersDataSource.getThemeMode();

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
    return await _usersDataSource.getUser();
  }

  @override
  Future<void> saveExcludeConfirmation(bool value) async {
    return await _usersDataSource.saveExcludeConfirmation(value);
  }

  @override
  Future<void> saveReplaceLanguage(bool value) async {
    return await _usersDataSource.saveReplaceLanguage(value);
  }

  @override
  Future<void> saveThemeMode(ThemeMode theme) async {
    String themeAsString = theme.toString().split('.').last.toLowerCase();

    return await _usersDataSource.saveThemeMode(themeAsString);
  }
}
