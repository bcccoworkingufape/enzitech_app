import 'package:dartz/dartz.dart';

import '../../entities/user_entity.dart';
import '../../../../../core/failures/failure.dart';

abstract class LoginUseCase {
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  });
}
