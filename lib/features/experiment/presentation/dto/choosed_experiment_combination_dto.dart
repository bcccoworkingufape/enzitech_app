// 🌎 Project imports:
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../treatment/domain/entities/treatment_entity.dart';

class ChoosedExperimentCombinationDTO {
  EnzymeEntity? enzyme;
  TreatmentEntity? treatment;

  ChoosedExperimentCombinationDTO({
    this.enzyme,
    this.treatment,
  });

  @override
  String toString() {
    return "{enzyme: $enzyme, treatment: $treatment}";
  }
}
