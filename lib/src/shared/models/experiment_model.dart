// 🎯 Dart imports:
import 'dart:convert';

class ExperimentModel {
  String name;
  String description;
  int repetitions;
  double progress;
  DateTime createdAt;
  DateTime updatedAt;

  ExperimentModel({
    required this.name,
    required this.description,
    required this.repetitions,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  ExperimentModel copyWith(
    String name,
    String description,
    int repetitions,
    double progress,
    DateTime createdAt,
    DateTime updatedAt,
  ) {
    return ExperimentModel(
      name: name,
      description: description,
      repetitions: repetitions,
      progress: progress,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'repetitions': repetitions,
      'progress': progress,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

  factory ExperimentModel.fromMap(Map<String, dynamic> map) {
    return ExperimentModel(
      name: map['name'],
      description: map['description'],
      repetitions: map['repetitions'],
      progress: double.parse(map['progress']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExperimentModel.fromJson(String source) =>
      ExperimentModel.fromMap(json.decode(source));
}
