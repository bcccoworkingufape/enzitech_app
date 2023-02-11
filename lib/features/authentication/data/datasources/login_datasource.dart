import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/failures/failure.dart';

abstract class LoginDataSource {
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  });
}
