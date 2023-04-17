// 🌎 Project imports:
import 'experiment_entity.dart';

class ExperimentPaginationEntity {
  int total;
  List<ExperimentEntity> experiments;

  ExperimentPaginationEntity({
    required this.total,
    required this.experiments,
  });
}
