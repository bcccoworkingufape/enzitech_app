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

  @override
  Future<Either<Failure, Unit>> recoverPassword({required String email}) async {
    return await _authRepository.recoverPassword(email: email);
  }

  @override
  Future<Either<Failure, Unit>> verifyPin({required String email, required String token}) async {
    return await _authRepository.verifyPin(email: email, token: token);
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    return await _authRepository.resetPassword(email: email, token: token, newPassword: newPassword);
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    return await _authRepository.deleteAccount();
  }
}
