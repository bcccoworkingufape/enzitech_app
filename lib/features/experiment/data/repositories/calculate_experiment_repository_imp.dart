// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/experiment_calculation_entity.dart';
import '../../domain/repositories/calculate_experiment_repository.dart';
import '../datasources/calculate_experiment_datasource.dart';

class CalculateExperimentRepositoryImp
    implements CalculateExperimentRepository {
  final CalculateExperimentDataSource _calculateExperimentDataSource;

  CalculateExperimentRepositoryImp(this._calculateExperimentDataSource);

  @override
  Future<Either<Failure, ExperimentCalculationEntity>> call({
    required String enzymeId,
    required String treatmentID,
    required Map<String, dynamic> experimentData,
  }) async {
    return await _calculateExperimentDataSource(
      enzymeId: enzymeId,
      treatmentID: treatmentID,
      experimentData: experimentData,
    );
  }
}
