// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../repositories/get_enzymes_remaining_in_experiment_repository.dart';
import 'get_enzymes_remaining_in_experiment_usecase.dart';

class GetEnzymesRemainingInExperimentUseCaseImp
    implements GetEnzymesRemainingInExperimentUseCase {
  final GetEnzymesRemainingInExperimentRepository
      _getEnzymesRemainingInExperimentRepository;

  GetEnzymesRemainingInExperimentUseCaseImp(
    this._getEnzymesRemainingInExperimentRepository,
  );

  @override
  Future<Either<Failure, List<EnzymeEntity>>> call({
    required String experimentId,
    required String treatmentId,
  }) async {
    return await _getEnzymesRemainingInExperimentRepository.call(
      experimentId: experimentId,
      treatmentId: treatmentId,
    );
  }
}
