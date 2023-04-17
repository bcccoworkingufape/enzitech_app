// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/experiment_entity.dart';

abstract class GetExperimentByIdRepository {
  Future<Either<Failure, ExperimentEntity>> call(String id);
}
