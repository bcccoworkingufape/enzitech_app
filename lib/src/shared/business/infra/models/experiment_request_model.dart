// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';

class ExperimentRequestModel {
  String name;
  String description;
  int repetitions;
  List<String> processes;
  List<EnzymeEntity> experimentsEnzymes;

  ExperimentRequestModel({
    required this.name,
    required this.description,
    required this.repetitions,
    required this.processes,
    required this.experimentsEnzymes,
  });

  ExperimentRequestModel copyWith(
    String name,
    String description,
    int repetitions,
    List<String> processes,
    List<EnzymeEntity> experimentsEnzymes,
  ) {
    return ExperimentRequestModel(
      name: name,
      description: description,
      repetitions: repetitions,
      processes: processes,
      experimentsEnzymes: experimentsEnzymes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'repetitions': repetitions,
      'processes': processes,
      'experimentsEnzymes': experimentsEnzymes,
    };
  }

  factory ExperimentRequestModel.fromMap(Map<String, dynamic> map) {
    return ExperimentRequestModel(
      name: map['name'],
      description: map['description'],
      repetitions: map['repetitions'],
      processes: map['processes'],
      experimentsEnzymes: map['experimentsEnzymes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExperimentRequestModel.fromJson(String source) =>
      ExperimentRequestModel.fromMap(json.decode(source));
}
