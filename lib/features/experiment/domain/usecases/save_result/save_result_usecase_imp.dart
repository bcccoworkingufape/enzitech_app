// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../entities/experiment_entity.dart';
import '../../repositories/save_result_repository.dart';
import 'save_result_usecase.dart';

class SaveResultUseCaseImp implements SaveResultUseCase {
  final SaveResultRepository _saveResultRepository;

  SaveResultUseCaseImp(
    this._saveResultRepository,
  );

  @override
  Future<Either<Failure, ExperimentEntity>> call({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
    required List<num> results,
    required num average,
  }) async {
    return await _saveResultRepository.call(
      experimentId: experimentId,
      enzymeId: enzymeId,
      treatmentID: treatmentID,
      listOfExperimentData: listOfExperimentData,
      results: results,
      average: average,
    );
  }
}
