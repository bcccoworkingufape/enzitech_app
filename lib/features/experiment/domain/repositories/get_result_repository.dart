// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/experiment_result_entity.dart';

abstract class GetResultRepository {
  Future<Either<Failure, ExperimentResultEntity>> call({required String experimentId});
}
