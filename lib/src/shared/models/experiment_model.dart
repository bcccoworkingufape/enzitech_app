// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/models/treatment_model.dart';

class ExperimentModel {
  String id;
  String name;
  String description;
  int repetitions;
  double progress;
  DateTime createdAt;
  DateTime updatedAt;
  List<TreatmentModel>? treatments;
  List<EnzymeModel>? enzymes;

  ExperimentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.repetitions,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
    this.treatments,
    this.enzymes,
  });

  // ExperimentModel copyWith(
  //   String id,
  //   String name,
  //   String description,
  //   int repetitions,
  //   double progress,
  //   DateTime createdAt,
  //   DateTime updatedAt,
  // ) {
  //   return ExperimentModel(
  //     id: id,
  //     name: name,
  //     description: description,
  //     repetitions: repetitions,
  //     progress: progress,
  //     createdAt: createdAt,
  //     updatedAt: updatedAt,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'repetitions': repetitions,
      'progress': progress,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'processes': treatments != null
          ? treatments!.map((x) => x.toMap()).toList()
          : null,
      'enzymes':
          enzymes != null ? enzymes!.map((x) => x.toMap()).toList() : null,
    };
  }

  factory ExperimentModel.fromMap(Map<String, dynamic> map) {
    return ExperimentModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      repetitions: map['repetitions'],
      progress: double.parse(map['progress']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      treatments: map['processes'] != null
          ? List<TreatmentModel>.from(
              map['processes']?.map((x) => TreatmentModel.fromMap(x)))
          : null,
      enzymes: map['enzymes'] != null
          ? List<EnzymeModel>.from(
              map['enzymes']?.map((x) => EnzymeModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExperimentModel.fromJson(String source) =>
      ExperimentModel.fromMap(json.decode(source));
}
