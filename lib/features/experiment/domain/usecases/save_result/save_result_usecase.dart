// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';
import '../../entities/experiment_entity.dart';

abstract class SaveResultUseCase {
  Future<Either<Failure, ExperimentEntity>> call({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<double> results,
    required double average,
  });
}
