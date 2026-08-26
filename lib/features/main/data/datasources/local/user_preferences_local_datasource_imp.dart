// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/key_value/key_value_service.dart';
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../core/failures/database_failures/no_result_query_failure.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../authentication/data/dto/user_dto.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../user_preferences_datasource.dart';

class UserPreferencesLocalDataSourceImp extends UserPreferencesDataSource {
  static const _experimentsCacheKey = 'experiments_cache';
  static const _treatmentsCacheKey = 'treatments_cache';
  static const _enzymesCacheKey = 'enzymes_cache';

  final UserPreferencesService _userPreferencesService;
  final KeyValueService _keyValueService;

  UserPreferencesLocalDataSourceImp(this._userPreferencesService, this._keyValueService);

  @override
  Future<void> clearUser() async {
    // Remove os dados do usuário e todos os caches offline conhecidos (melhor esforço; o próprio token seguro é removido pelo SettingsViewmodel via SecureSessionStorage).
    await _userPreferencesService.clearAllAndKeepTheme();
    await _keyValueService.remove(_experimentsCacheKey);
    await _keyValueService.remove(_treatmentsCacheKey);
    await _keyValueService.remove(_enzymesCacheKey);
  }

  @override
  Future<Either<Failure, bool>> getExcludeConfirmation() async {
    try {
      var response = await _userPreferencesService.getExcludeConfirmation();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, bool>> getReplaceLanguage() async {
    try {
      var response = await _userPreferencesService.getReplaceLanguage();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, String>> getThemeMode() async {
    try {
      var response = await _userPreferencesService.getThemeModeAsString();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      var response = await _userPreferencesService.getFullUser();
      if (response == null) {
        throw NoResultQueryFailure(message: "os dados do usuário");
      } else {
        // Compatibilidade com versões anteriores: o payload legado também armazenava o accessToken. Agora removemos isso antes da decodificação.
        final raw = jsonDecode(response);
        if (raw is Map<String, dynamic>) {
          raw.remove('accessToken');
          var result = UserDto.fromJson(raw);
          return Right(result);
        }
        var result = UserDto.fromJson(jsonDecode(response));
        return Right(result);
      }
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<void> saveExcludeConfirmation(bool value) async {
    await _userPreferencesService.saveExcludeConfirmation(value);
  }

  @override
  Future<void> saveReplaceLanguage(bool value) async {
    await _userPreferencesService.saveReplaceLanguage(value);
  }

  @override
  Future<void> saveThemeMode(String value) async {
    await _userPreferencesService.saveThemeModeAsString(value);
  }
}
