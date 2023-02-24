// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';

abstract class GetExcludeConfirmationRepository {
  Future<Either<Failure, bool>> call();
}
