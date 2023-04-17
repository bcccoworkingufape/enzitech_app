// 🌎 Project imports:
import '../../entities/experiment_pagination_entity.dart';
import '../../repositories/store_experiments_in_cache_repository.dart';
import 'store_experiments_in_cache_usecase.dart';

class StoreExperimentsInCacheUseCaseImp
    implements StoreExperimentsInCacheUseCase {
  final StoreExperimentsInCacheRepository _storeExperimentsInCacheRepository;

  StoreExperimentsInCacheUseCaseImp(
    this._storeExperimentsInCacheRepository,
  );

  @override
  Future<void> call(
      ExperimentPaginationEntity experimentPaginationEntity) async {
    return await _storeExperimentsInCacheRepository
        .call(experimentPaginationEntity);
  }
}
