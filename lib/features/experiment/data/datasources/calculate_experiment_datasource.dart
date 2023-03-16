// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_calculation_entity.dart';

abstract class CalculateExperimentDataSource {
  Future<Either<Failure, ExperimentCalculationEntity>> call({
    required String enzymeId,
    required String treatmentID,
    required Map<String, dynamic> experimentData,
  });
}
