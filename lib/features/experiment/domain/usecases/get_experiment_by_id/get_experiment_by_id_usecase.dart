// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';
import '../../entities/experiment_entity.dart';

abstract class GetExperimentByIdUseCase {
  Future<Either<Failure, ExperimentEntity>> call(String id);
}
