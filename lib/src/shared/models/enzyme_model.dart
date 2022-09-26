// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/extensions/extensions.dart';
import '../util/util.dart';

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

  Map<String, dynamic> toMapCreateExperiment(
    int duration,
    double weightSample,
    double weightGround,
    double size,
  ) {
    return {
      'enzyme': id,
      'variableA': variableA,
      'variableB': variableB,
      'duration': duration,
      'weightSample': weightSample,
      'weightGround': weightGround,
      'size': size,
    };
  }

  factory EnzymeModel.fromMap(Map<String, dynamic> map) {
    return EnzymeModel(
      id: map['id'],
      name: map['name'],
      variableA: double.parse(map['variableA']).toPrecision(3),
      variableB: double.parse(map['variableB']).toPrecision(3),
      type: map['type'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap(), toEncodable: Toolkit.encodeDateTime);

  String toJsonCreateExperiment(
    int duration,
    double weightSample,
    double weightGround,
    double size,
  ) =>
      json.encode(
        toMapCreateExperiment(duration, weightSample, weightGround, size),
        toEncodable: Toolkit.encodeDateTime,
      );

  factory EnzymeModel.fromJson(String source) =>
      EnzymeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return "{id: $id, name: $name, variableA: $variableA, variableB: $variableB, type: $type}";
  }
}
