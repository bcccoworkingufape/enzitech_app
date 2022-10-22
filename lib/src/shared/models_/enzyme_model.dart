// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/utilities/extensions/extensions.dart';
import 'package:enzitech_app/src/shared/utilities/util/util.dart';

class EnzymeModel {
  String id;
  String name;
  double variableA;
  double variableB;
  String type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? duration;
  double? weightSample;
  double? weightGround;
  double? size;

  EnzymeModel({
    required this.id,
    required this.name,
    required this.variableA,
    required this.variableB,
    required this.type,
    this.createdAt,
    this.updatedAt,
    this.duration,
    this.weightSample,
    this.weightGround,
    this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'variableA': variableA,
      'variableB': variableB,
      'type': type,
      'createdAt': createdAt?.toString(),
      'updatedAt': updatedAt?.toString(),
      'duration': duration,
      'weightSample': weightSample,
      'weightGround': weightGround,
      'size': size,
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
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      duration: map['duration'] != null ? int.parse(map['duration']) : null,
      weightSample: map['weightSample'] != null
          ? double.parse(map['weightSample'])
          : null,
      weightGround: map['weightGround'] != null
          ? double.parse(map['weightGround'])
          : null,
      size: map['size'] != null ? double.parse(map['size']) : null,
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
