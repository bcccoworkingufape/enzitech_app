// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/create_account_repository.dart';
import '../datasources/create_account_datasource.dart';

class CreateAccountRepositoryImp implements CreateAccountRepository {
  final CreateAccountDataSource _createAccountDataSource;

  CreateAccountRepositoryImp(this._createAccountDataSource);

  @override
  Future<Either<Failure, Unit>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _createAccountDataSource(
      name: name,
      email: email,
      password: password,
    );
  }
}
