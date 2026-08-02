// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../core/failures/server_failures/server_failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/user_entity.dart';
import '../../dto/user_dto.dart';
import '../auth_datasource.dart';

class AuthRemoteDataSourceImp implements AuthDataSource {
  final HttpService _httpService;
  final UserPreferencesService _userPreferencesService;

  AuthRemoteDataSourceImp(this._httpService, this._userPreferencesService);

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async {
    try {
      var response = await _httpService.post(API.REQUEST_LOGIN, data: {'email': email, 'password': password});
      var result = UserDto.fromJson(response.data);

      await _userPreferencesService.saveFullUser(jsonEncode(response.data));
      await _userPreferencesService.saveToken(result.token);
      await _httpService.setConfig(token: result.token);

      await _userPreferencesService.initConfirmationsEnabled();
      await _userPreferencesService.initThemeMode();

      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Falha não mapeada: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> recoverPassword({required String email}) async {
    try {
      await _httpService.post(API.REQUEST_RECOVER_EMAIL, data: {'email': email});
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Falha não mapeada: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyPin({required String email, required String token}) async {
    try {
      await _httpService.post(API.REQUEST_VERIFY_PIN, data: {'email': email, 'token': token});
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Falha não mapeada: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      await _httpService.post(
        API.REQUEST_RESET_PASSWORD,
        data: {'email': email, 'token': token, 'newPassword': newPassword},
      );
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Falha não mapeada: $e'));
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

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await _httpService.delete(API.REQUEST_DELETE_MY_ACCOUNT);
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Falha não mapeada: $e'));
    }
  }
}
