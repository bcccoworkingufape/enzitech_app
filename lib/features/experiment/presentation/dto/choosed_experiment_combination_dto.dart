// 🌎 Project imports:
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../treatment/domain/entities/treatment_entity.dart';

class ChoosedExperimentCombinationDTO {
  List<EnzymeEntity> enzymes;
  List<TreatmentEntity> treatments;

  ChoosedExperimentCombinationDTO({this.enzymes = const [], this.treatments = const []});

  @override
  String toString() {
    return "{enzymes: $enzymes, treatments: $treatments}";
  }
}
