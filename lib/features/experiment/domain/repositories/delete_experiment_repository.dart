// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';

abstract class DeleteExperimentRepository {
  Future<Either<Failure, Unit>> call(String id);
}
