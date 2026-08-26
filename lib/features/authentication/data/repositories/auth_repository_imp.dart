// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImp(this._authDataSource);

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async {
    return await _authDataSource.login(email: email, password: password);
  }

  @override
  Future<Either<Failure, Unit>> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authDataSource.createAccount(name: name, email: email, password: password);
  }

  @override
  Future<Either<Failure, Unit>> recoverPassword({required String email}) async {
    return await _authDataSource.recoverPassword(email: email);
  }

  @override
  Future<Either<Failure, Unit>> verifyPin({required String email, required String token}) async {
    return await _authDataSource.verifyPin(email: email, token: token);
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    return await _authDataSource.resetPassword(email: email, token: token, newPassword: newPassword);
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    return await _authDataSource.deleteAccount();
  }
}
