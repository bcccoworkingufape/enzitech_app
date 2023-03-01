// 🌎 Project imports:
import '../entities/experiment_pagination_entity.dart';

abstract class StoreExperimentsInCacheRepository {
  Future<void> call(ExperimentPaginationEntity experimentPaginationEntity);
}
