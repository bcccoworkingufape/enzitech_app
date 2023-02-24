// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';

abstract class GetExcludeConfirmationDataSource {
  Future<Either<Failure, bool>> call();
}
