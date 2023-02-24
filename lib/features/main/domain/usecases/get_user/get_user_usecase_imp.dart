// 📦 Package imports:
import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failure.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../repositories/get_user_repository.dart';
import 'get_user_usecase.dart';

class GetUserUseCaseImp implements GetUserUseCase {
  final GetUserRepository _getUserRepository;

  GetUserUseCaseImp(this._getUserRepository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await _getUserRepository();
  }
}
