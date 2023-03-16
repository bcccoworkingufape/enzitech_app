// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';
import '../../entities/experiment_calculation_entity.dart';

abstract class CalculateExperimentUseCase {
  Future<Either<Failure, ExperimentCalculationEntity>> call({
    required String enzymeId,
    required String treatmentID,
    required Map<String, dynamic> experimentData,
  });
}
