// 🌎 Project imports:
import '../../domain/entities/experiment_enzyme_result_entity.dart';
import '../../domain/entities/experiment_result_entity.dart';
import 'experiment_enzyme_result_dto.dart';

extension ExperimentResultDto on ExperimentResultEntity {
  static ExperimentResultEntity fromJson(Map json) {
    return ExperimentResultEntity(
      enzymes: List<ExperimentEnzymeResultEntity>.from(
        json['result'].map(
          (x) => ExperimentEnzymeResultDto.fromJson(x),
        ),
      ),
    );
  }

  Map toJson() {
    return {
      'result': enzymes.map((x) => x.toJson()).toList(),
    };
  }
}
