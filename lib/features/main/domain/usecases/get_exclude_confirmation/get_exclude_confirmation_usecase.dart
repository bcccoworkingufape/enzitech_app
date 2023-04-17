// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';

abstract class GetExcludeConfirmationUseCase {
  Future<Either<Failure, bool>> call();
}
