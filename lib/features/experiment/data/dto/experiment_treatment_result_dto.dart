// 🌎 Project imports:
import '../../domain/entities/experiment_repetition_result_entity.dart';
import '../../domain/entities/experiment_treatment_result_entity.dart';
import 'experiment_repetition_result_dto.dart';

extension ExperimentTreatmentResultDto on ExperimentTreatmentResultEntity {
  static ExperimentTreatmentResultEntity fromJson(Map json) {
    return ExperimentTreatmentResultEntity(
      treatmentName: json['processName'],
      repetitionResults: List<ExperimentRepetitionResultEntity>.from(
        json['results'].map(
          (x) => ExperimentRepetitionResultDto.fromJson(x),
        ),
      ),
    );
  }

  Map toJson() {
    return {
      'processName': treatmentName,
      'results': repetitionResults.map((x) => x.toJson()).toList(),
    };
  }
}
