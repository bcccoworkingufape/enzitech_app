// 🌎 Project imports:
import '../../../enzyme/data/dto/enzyme_dto.dart';
import '../../domain/entities/experiment_enzyme_result_entity.dart';
import '../../domain/entities/experiment_treatment_result_entity.dart';
import 'experiment_treatment_result_dto.dart';

extension ExperimentEnzymeResultDto on ExperimentEnzymeResultEntity {
  static ExperimentEnzymeResultEntity fromJson(Map json) {
    return ExperimentEnzymeResultEntity(
      enzyme: EnzymeDto.fromJson(json['enzyme']),
      treatments: List<ExperimentTreatmentResultEntity>.from(
        json['processes'].map(
          (x) => ExperimentTreatmentResultDto.fromJson(x),
        ),
      ),
    );
  }

  Map toJson() {
    return {
      'enzyme': enzyme,
      'processes': treatments.map((x) => x.toJson()).toList(),
    };
  }
}
