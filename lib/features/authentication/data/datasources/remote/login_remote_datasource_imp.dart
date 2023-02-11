// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/user_entity.dart';
import '../../dto/user_dto.dart';
import '../login_datasource.dart';

class LoginRemoteDataSourceImp implements LoginDataSource {
  final HttpService _httpService;
  final UserPreferencesServices _userPreferencesServices;

  LoginRemoteDataSourceImp(this._httpService, this._userPreferencesServices);

  @override
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    try {
      var response = await _httpService.post(API.REQUEST_LOGIN, data: {
        'email': email,
        'password': password,
      });
      var result = UserDto.fromJson(response.data);

      await _userPreferencesServices.saveFullUser(jsonEncode(response.data));
      await _userPreferencesServices.saveToken(result.token);
      await _userPreferencesServices.initConfirmationsEnabled();

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
