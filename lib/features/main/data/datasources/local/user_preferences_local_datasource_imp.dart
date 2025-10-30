// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../core/failures/database_failures/no_result_query_failure.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../authentication/data/dto/user_dto.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../user_preferences_datasource.dart';

class UserPreferencesLocalDataSourceImp extends UserPreferencesDataSource {
  final UserPreferencesServices _userPreferencesServices;

  UserPreferencesLocalDataSourceImp(this._userPreferencesServices);

  @override
  Future<void> clearUser() async {
    await _userPreferencesServices.clearAllAndKeepTheme();
  }

  @override
  Future<Either<Failure, bool>> getExcludeConfirmation() async {
    try {
      var response = await _userPreferencesServices.getExcludeConfirmation();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, bool>> getReplaceLanguage() async {
    try {
      var response = await _userPreferencesServices.getReplaceLanguage();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, String>> getThemeMode() async {
    try {
      var response = await _userPreferencesServices.getThemeModeAsString();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      var response = await _userPreferencesServices.getFullUser();
      if (response == null) {
        throw NoResultQueryFailure(message: "os dados do usuário");
      } else {
        var result = UserDto.fromJson(jsonDecode(response));
        return Right(result);
      }
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<void> saveExcludeConfirmation(bool value) async {
    await _userPreferencesServices.saveExcludeConfirmation(value);
  }

  @override
  Future<void> saveReplaceLanguage(bool value) async {
    await _userPreferencesServices.saveReplaceLanguage(value);
  }

  @override
  Future<void> saveThemeMode(String value) async {
    await _userPreferencesServices.saveThemeModeAsString(value);
  }
}
