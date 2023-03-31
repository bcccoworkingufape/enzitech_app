// 🌎 Project imports:
import '../../domain/entities/experiment_enzyme_result_entity.dart';
import '../../domain/entities/experiment_treatment_result_entity.dart';
import 'experiment_treatment_result_dto.dart';

extension ExperimentEnzymeResultDto on ExperimentEnzymeResultEntity {
  static ExperimentEnzymeResultEntity fromJson(Map json) {
    return ExperimentEnzymeResultEntity(
      enzymeName: json['enzymeName'],
      treatments: List<ExperimentTreatmentResultEntity>.from(
        json['processes'].map(
          (x) => ExperimentTreatmentResultDto.fromJson(x),
        ),
      ),
    );
  }

  Map toJson() {
    return {
      'treatmentName': enzymeName,
      'processes': treatments.map((x) => x.toJson()).toList(),
    };
  }
}
