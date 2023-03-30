import '../../../enzyme/domain/entities/enzyme_entity.dart';

class ChoosedExperimentCombinationDTO {
  EnzymeEntity? enzyme;
  String? treatmentId;
  String? treatmentName;

  ChoosedExperimentCombinationDTO({
    this.enzyme,
    this.treatmentId,
    this.treatmentName,
  });

  @override
  String toString() {
    return "{enzyme: $enzyme, treatmentId: $treatmentId}, treatmentName: $treatmentName}";
  }
}
