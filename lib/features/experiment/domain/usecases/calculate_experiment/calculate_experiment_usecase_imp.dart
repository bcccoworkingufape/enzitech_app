// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../entities/experiment_calculation_entity.dart';
import '../../repositories/calculate_experiment_repository.dart';
import 'calculate_experiment_usecase.dart';

class CalculateExperimentUseCaseImp implements CalculateExperimentUseCase {
  final CalculateExperimentRepository _calculateExperimentRepository;

  CalculateExperimentUseCaseImp(
    this._calculateExperimentRepository,
  );

  @override
  Future<Either<Failure, ExperimentCalculationEntity>> call({
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
  }) async {
    return await _calculateExperimentRepository.call(
      enzymeId: enzymeId,
      treatmentID: treatmentID,
      listOfExperimentData: listOfExperimentData,
    );
  }
}
