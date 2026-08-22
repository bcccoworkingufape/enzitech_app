// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../authentication/domain/entities/user_entity.dart';

abstract class UserPreferencesUseCases {
  Future<void> clearUser();

  Future<Either<Failure, bool>> getExcludeConfirmation();

  Future<Either<Failure, bool>> getReplaceLanguage();

  Future<ThemeMode> getThemeMode();

  Future<Either<Failure, UserEntity>> getUser();

  Future<void> saveExcludeConfirmation(bool value);

  Future<void> saveReplaceLanguage(bool value);

  Future<void> saveThemeMode(ThemeMode theme);
}
