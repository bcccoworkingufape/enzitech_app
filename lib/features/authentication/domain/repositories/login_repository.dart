import 'package:dartz/dartz.dart';

import '../entities/user_entity.dart';
import '../../../../core/failures/failure.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  });
}
