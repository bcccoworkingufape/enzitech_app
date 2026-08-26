// 🌎 Project imports:

// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../repositories/user_preferences_repository.dart';
import 'user_preferences_usecases.dart';

class UserPreferencesUseCasesImp implements UserPreferencesUseCases {
  final UserPreferencesRepository _userPreferencesRepository;

  UserPreferencesUseCasesImp(this._userPreferencesRepository);

  @override
  Future<void> clearUser() async {
    await _userPreferencesRepository.clearUser();
  }

  @override
  Future<Either<Failure, bool>> getExcludeConfirmation() async {
    return await _userPreferencesRepository.getExcludeConfirmation();
  }

  @override
  Future<Either<Failure, bool>> getReplaceLanguage() async {
    return await _userPreferencesRepository.getReplaceLanguage();
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    return await _userPreferencesRepository.getThemeMode();
  }

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    return await _userPreferencesRepository.getUser();
  }

  @override
  Future<void> saveExcludeConfirmation(bool value) async {
    await _userPreferencesRepository.saveExcludeConfirmation(value);
  }

  @override
  Future<void> saveReplaceLanguage(bool value) async {
    await _userPreferencesRepository.saveReplaceLanguage(value);
  }

  @override
  Future<void> saveThemeMode(ThemeMode theme) async {
    await _userPreferencesRepository.saveThemeMode(theme);
  }
}
