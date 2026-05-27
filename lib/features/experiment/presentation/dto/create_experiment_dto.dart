// 🌎 Project imports:
import 'dart:convert';
import '../../../enzyme/domain/entities/enzyme_entity.dart';

class CreateExperimentDTO {
  String? name;
  String? description;
  int? repetitions;
  List<String>? treatmentsIDs;
  List<EnzymeEntity>? enzymes;
  int? savedStep;
  Map<String, String>? formValues;

  CreateExperimentDTO({this.name, this.description, this.repetitions,
    this.treatmentsIDs, this.enzymes, this.savedStep, this.formValues});

  Map<String, dynamic> toMap(){
    return{
        'name': name,
        'description': description,
        'repetitions': repetitions,
        'treatmentsIDs': treatmentsIDs,
        'savedStep': savedStep,
        'enzymes': enzymes?.map((x) => x.toMap()).toList(),
        'formValues': formValues
    };
  }

  factory CreateExperimentDTO.fromMap(Map<String, dynamic> map){
    return CreateExperimentDTO(
      name: map['name'],
      description: map['description'],
      repetitions: map['repetitions'],
      treatmentsIDs: map['treatmentsIDs'] != null ? List<String>.from(map['treatmentsIDs']) : null,
      savedStep: map['savedStep'],
      enzymes: map['enzymes'] != null
          ? List<EnzymeEntity>.from(map['enzymes'].map((x) => EnzymeEntity.fromMap(x)))
          : null,
      formValues: map['formValues'] != null ? Map<String, String>.from(map['formValues']) : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory CreateExperimentDTO.fromJson(String source) => CreateExperimentDTO.fromMap(json.decode(source));

  @override
  String toString() {
    return "{name: $name, description: $description, repetitions: $repetitions, "
        "treatmentsIDs: $treatmentsIDs, enzymes: $enzymes, savedStep: $savedStep,"
        "formValues: $formValues}";
  }
}
