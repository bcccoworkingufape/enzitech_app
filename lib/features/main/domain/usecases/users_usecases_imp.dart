// 🌎 Project imports:
// 🌎 Project imports:
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/failures/failure.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/users_repository.dart';
import 'users_usecases.dart';

class UsersUseCasesImp implements UsersUseCases {
  final UsersRepository _usersRepository;

  UsersUseCasesImp(this._usersRepository);

  @override
  void clearUser() async {
    return _usersRepository.clearUser();
  }

  @override
  Future<Either<Failure, bool>> getExcludeConfirmation() async {
    return await _usersRepository.getExcludeConfirmation();
  }

  @override
  Future<Either<Failure, bool>> getReplaceLanguage() async {
    return await _usersRepository.getReplaceLanguage();
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    return await _usersRepository.getThemeMode();
  }

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    return await _usersRepository.getUser();
  }

  @override
  Future<void> saveExcludeConfirmation(bool value) async {
    return await _usersRepository.saveExcludeConfirmation(value);
  }

  @override
  Future<void> saveReplaceLanguage(bool value) async {
    return await _usersRepository.saveReplaceLanguage(value);
  }

  @override
  Future<void> saveThemeMode(ThemeMode theme) async {
    return await _usersRepository.saveThemeMode(theme);
  }
}
