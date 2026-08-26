// 🌎 Project imports:
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import 'pending_treatment_dto.dart';

class CreateExperimentDTO {
  String? name;
  String? description;
  int? repetitions;
  List<PendingTreatmentDTO>? treatments;
  List<EnzymeEntity>? enzymes;

  CreateExperimentDTO({this.name, this.description, this.repetitions, this.treatments, this.enzymes});

  @override
  String toString() {
    return "{name: $name, description: $description, repetitions: $repetitions, treatments: $treatments, enzymes: $enzymes}";
  }
}
