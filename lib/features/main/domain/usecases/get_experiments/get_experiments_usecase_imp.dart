// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../entities/experiment_entity.dart';
import '../../entities/experiment_pagination_entity.dart';
import '../../repositories/get_experiments_repository.dart';
import 'get_experiments_usecase.dart';

class GetExperimentsUseCaseImp implements GetExperimentsUseCase {
  final GetExperimentsRepository _getExperimentsRepository;

  GetExperimentsUseCaseImp(
    this._getExperimentsRepository,
  );

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> call(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    return await _getExperimentsRepository.call(
      page,
      orderBy: orderBy,
      ordering: ordering,
      limit: limit,
      finished: finished,
    );
  }
}
