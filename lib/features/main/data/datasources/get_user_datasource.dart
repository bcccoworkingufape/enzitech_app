// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../../authentication/domain/entities/user_entity.dart';

abstract class GetUserDataSource {
  Future<Either<Failure, UserEntity>> call();
}
