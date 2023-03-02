// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_entity.dart';

abstract class GetExperimentByIdDataSource {
  Future<Either<Failure, ExperimentEntity>> call(String id);
}
