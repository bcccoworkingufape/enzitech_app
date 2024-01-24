// 🌎 Project imports:
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import 'experiment_treatment_result_entity.dart';

class ExperimentEnzymeResultEntity {
  ExperimentEnzymeResultEntity({
    required this.enzyme,
    required this.treatments,
  });

  final EnzymeEntity enzyme;
  final List<ExperimentTreatmentResultEntity> treatments;
}
