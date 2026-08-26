// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthDataSource {
  Future<Either<Failure, UserEntity>> login({required String email, required String password});
  Future<Either<Failure, Unit>> createAccount({required String name, required String email, required String password});
  Future<Either<Failure, Unit>> recoverPassword({required String email});
  Future<Either<Failure, Unit>> verifyPin({required String email, required String token});
  Future<Either<Failure, Unit>> resetPassword({required String email, required String token, required String newPassword});
}
