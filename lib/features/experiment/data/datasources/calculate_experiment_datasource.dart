// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_calculation_entity.dart';

abstract class CalculateExperimentDataSource {
  Future<Either<Failure, ExperimentCalculationEntity>> call({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
  });
}
