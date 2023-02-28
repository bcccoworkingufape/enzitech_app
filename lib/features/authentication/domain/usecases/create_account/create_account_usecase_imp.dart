// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../repositories/create_account_repository.dart';
import 'create_account_usecase.dart';

class CreateAccountUseCaseImp implements CreateAccountUseCase {
  final CreateAccountRepository _createAccountRepository;

  CreateAccountUseCaseImp(this._createAccountRepository);

  @override
  Future<Either<Failure, bool>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _createAccountRepository.call(
      name: name,
      email: email,
      password: password,
    );
  }
}
