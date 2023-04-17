// 🌎 Project imports:
import '../../../enzyme/domain/entities/enzyme_entity.dart';

class CreateExperimentDTO {
  String? name;
  String? description;
  int? repetitions;
  List<String>? treatmentsIDs;
  List<EnzymeEntity>? enzymes;

  CreateExperimentDTO({
    this.name,
    this.description,
    this.repetitions,
    this.treatmentsIDs,
    this.enzymes,
  });

  @override
  String toString() {
    return "{name: $name, description: $description, repetitions: $repetitions, treatmentsIDs: $treatmentsIDs, enzymes: $enzymes}";
  }
}
