// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';
import 'auth_usecase.dart';

class AuthUseCaseImp implements AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCaseImp(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async {
    return await _authRepository.login(email: email, password: password);
  }

  @override
  Future<Either<Failure, Unit>> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authRepository.createAccount(name: name, email: email, password: password);
  }
}
