// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../entities/user_entity.dart';
import '../../repositories/login_repository.dart';
import 'login_usecase.dart';

class LoginUseCaseImp implements LoginUseCase {
  final LoginRepository _loginRepository;

  LoginUseCaseImp(this._loginRepository);

  @override
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await _loginRepository.call(email: email, password: password);
  }
}
