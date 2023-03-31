// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../entities/experiment_result_entity.dart';
import '../../repositories/get_result_repository.dart';
import 'get_result_usecase.dart';

class GetResultUseCaseImp implements GetResultUseCase {
  final GetResultRepository _getResultRepository;

  GetResultUseCaseImp(
    this._getResultRepository,
  );

  @override
  Future<Either<Failure, ExperimentResultEntity>> call({
    required String experimentId,
  }) async {
    return await _getResultRepository.call(
      experimentId: experimentId,
    );
  }
}
