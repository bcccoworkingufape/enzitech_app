// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../entities/experiment_entity.dart';
import '../../repositories/create_experiment_repository.dart';
import 'create_experiment_usecase.dart';

class CreateExperimentUseCaseImp implements CreateExperimentUseCase {
  final CreateExperimentRepository _createExperimentRepository;

  CreateExperimentUseCaseImp(
    this._createExperimentRepository,
  );

  @override
  Future<Either<Failure, ExperimentEntity>> call({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    return await _createExperimentRepository.call(
      name: name,
      description: description,
      repetitions: repetitions,
      treatmentsIDs: treatmentsIDs,
      enzymes: enzymes,
    );
  }
}
