// 🌎 Project imports:

import '../../entities/experiment_pagination_entity.dart';

abstract class StoreExperimentsInCacheUseCase {
  Future<void> call(ExperimentPaginationEntity experimentPaginationEntity);
}
