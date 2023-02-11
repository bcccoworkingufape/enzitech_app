// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_datasource.dart';

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
