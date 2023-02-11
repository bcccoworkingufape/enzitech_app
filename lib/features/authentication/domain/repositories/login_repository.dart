// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/user_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  });
}
