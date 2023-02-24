// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../authentication/domain/entities/user_entity.dart';

abstract class GetUserRepository {
  Future<Either<Failure, UserEntity>> call();
}
