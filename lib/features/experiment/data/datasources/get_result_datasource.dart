// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_result_entity.dart';

abstract class GetResultDataSource {
  Future<Either<Failure, ExperimentResultEntity>> call({
    required String experimentId,
  });
}
