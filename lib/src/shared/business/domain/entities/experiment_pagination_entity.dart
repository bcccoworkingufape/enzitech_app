// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';

class ExperimentPaginationEntity {
  int total;
  List<ExperimentEntity> experiments;

  ExperimentPaginationEntity({
    required this.total,
    required this.experiments,
  });
}
