// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../repositories/delete_experiment_repository.dart';
import 'delete_experiment_usecase.dart';

class DeleteExperimentUseCaseImp implements DeleteExperimentUseCase {
  final DeleteExperimentRepository _deleteExperimentRepository;

  DeleteExperimentUseCaseImp(
    this._deleteExperimentRepository,
  );

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await _deleteExperimentRepository.call(id);
  }
}
