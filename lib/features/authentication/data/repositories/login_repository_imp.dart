import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';

import '../../domain/repositories/login_repository.dart';
import '../datasources/login_datasource.dart';
import '../../../../core/failures/failure.dart';

class LoginRepositoryImp implements LoginRepository {
  final LoginDataSource _loginDataSource;

  LoginRepositoryImp(this._loginDataSource);

  @override
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await _loginDataSource(email: email, password: password);
  }
}
