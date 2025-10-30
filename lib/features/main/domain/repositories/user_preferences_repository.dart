import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/failures/failure.dart';
import '../../../authentication/domain/entities/user_entity.dart';

abstract class UserPreferencesRepository {
  void clearUser();

  Future<Either<Failure, bool>> getExcludeConfirmation();

  Future<Either<Failure, bool>> getReplaceLanguage();

  Future<ThemeMode> getThemeMode();

  Future<Either<Failure, UserEntity>> getUser();

  Future<void> saveExcludeConfirmation(bool value);

  Future<void> saveReplaceLanguage(bool value);

  Future<void> saveThemeMode(ThemeMode theme);
}
