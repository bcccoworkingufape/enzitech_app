// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../entities/experiment_entity.dart';
import '../../repositories/get_experiment_by_id_repository.dart';
import 'get_experiment_by_id_usecase.dart';

class GetExperimentByIdUseCaseImp implements GetExperimentByIdUseCase {
  final GetExperimentByIdRepository _getExperimentByIdRepository;

  GetExperimentByIdUseCaseImp(
    this._getExperimentByIdRepository,
  );

  @override
  Future<Either<Failure, ExperimentEntity>> call(String id) async {
    return await _getExperimentByIdRepository.call(id);
  }
}
