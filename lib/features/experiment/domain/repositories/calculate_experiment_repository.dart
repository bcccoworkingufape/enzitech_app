// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/experiment_calculation_entity.dart';

abstract class CalculateExperimentRepository {
  Future<Either<Failure, ExperimentCalculationEntity>> call({
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
  });
}
