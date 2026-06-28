// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/data/service/secure_storage/secure_session_storage.dart';
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/user_entity.dart';
import '../../dto/user_dto.dart';
import '../auth_datasource.dart';

class AuthRemoteDataSourceImp implements AuthDataSource {
  final HttpService _httpService;
  final UserPreferencesService _userPreferencesService;
  final SecureSessionStorage _secureSessionStorage;

  AuthRemoteDataSourceImp(this._httpService, this._userPreferencesService, this._secureSessionStorage);

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async {
    try {
      var response = await _httpService.post(API.REQUEST_LOGIN, data: {'email': email, 'password': password});
      var result = UserDto.fromJson(response.data);

      // Persiste um perfil sem o token de acesso. O próprio token vai
      // direto para o armazenamento seguro.
      final sanitized = {
        'user': response.data is Map && response.data['user'] is Map
            ? response.data['user']
            : {'name': result.name, 'email': result.email, 'id': result.id, 'role': result.userType.name},
      };
      await _userPreferencesService.saveFullUser(jsonEncode(sanitized));
      await _secureSessionStorage.writeToken(result.token);
      await _userPreferencesService.initConfirmationsEnabled();
      await _userPreferencesService.initThemeMode();

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _httpService.post(API.REQUEST_USERS, data: {'name': name, 'email': email, 'password': password});

      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
