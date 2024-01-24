// 🌎 Project imports:
import '../../../treatment/domain/entities/treatment_entity.dart';
import 'experiment_repetition_result_entity.dart';

class ExperimentTreatmentResultEntity {
  final TreatmentEntity treatment;
  final List<ExperimentRepetitionResultEntity> repetitionResults;

  ExperimentTreatmentResultEntity({
    required this.treatment,
    required this.repetitionResults,
  });
}
