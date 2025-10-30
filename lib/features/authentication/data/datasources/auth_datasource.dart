// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthDataSource {
  Future<Either<Failure, UserEntity>> login({required String email, required String password});
  Future<Either<Failure, Unit>> createAccount({required String name, required String email, required String password});
}
