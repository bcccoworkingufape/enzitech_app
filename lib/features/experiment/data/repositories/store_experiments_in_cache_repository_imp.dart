// 🌎 Project imports:
import '../../domain/entities/experiment_pagination_entity.dart';
import '../../domain/repositories/store_experiments_in_cache_repository.dart';
import '../datasources/get_experiments_datasource.dart';

class StoreExperimentsInCacheRepositoryImp
    implements StoreExperimentsInCacheRepository {
  final GetExperimentsDataSource _getExperimentsDataSource;

  StoreExperimentsInCacheRepositoryImp(this._getExperimentsDataSource);

  @override
  Future<void> call(
      ExperimentPaginationEntity experimentPaginationEntity) async {
    return await _getExperimentsDataSource
        .saveInCache(experimentPaginationEntity);
  }
}
