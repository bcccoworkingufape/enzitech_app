import 'experiment_repetition_result_entity.dart';

class ExperimentTreatmentResultEntity {
  final String treatmentName;
  final List<ExperimentRepetitionResultEntity> repetitionResults;

  ExperimentTreatmentResultEntity({
    required this.treatmentName,
    required this.repetitionResults,
  });
}
