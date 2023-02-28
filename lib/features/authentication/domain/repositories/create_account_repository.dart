// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';

abstract class CreateAccountRepository {
  Future<Either<Failure, bool>> call({
    required String name,
    required String email,
    required String password,
  });
}
