// 🎯 Dart imports:
import 'dart:convert';

class EnzymeModel {
  String id;
  String name;
  double variableA;
  double variableB;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  EnzymeModel({
    required this.id,
    required this.name,
    required this.variableA,
    required this.variableB,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  EnzymeModel copyWith(
    String id,
    String name,
    double variableA,
    double variableB,
    String type,
    DateTime createdAt,
    DateTime updatedAt,
  ) {
    return EnzymeModel(
      id: id,
      name: name,
      variableA: variableA,
      variableB: variableB,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'variableA': variableA,
      'variableB': variableB,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory EnzymeModel.fromMap(Map<String, dynamic> map) {
    return EnzymeModel(
      id: map['id'],
      name: map['name'],
      variableA: double.parse(map['variableA']),
      variableB: double.parse(map['variableB']),
      type: map['type'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EnzymeModel.fromJson(String source) =>
      EnzymeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return "{id: $id, name: $name, variableA: $variableA, variableB: $variableB, type: $type}";
  }
}
