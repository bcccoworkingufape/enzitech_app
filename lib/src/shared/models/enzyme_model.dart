// 🎯 Dart imports:
import 'dart:convert';

class EnzymeModel {
  String enzyme;
  double variableA;
  double variableB;
  double duration;
  double weightSample;
  double weightGround;
  double size;

  EnzymeModel({
    required this.enzyme,
    required this.variableA,
    required this.variableB,
    required this.duration,
    required this.weightSample,
    required this.weightGround,
    required this.size,
  });

  EnzymeModel copyWith(
    String enzyme,
    double variableA,
    double variableB,
    double duration,
    double weightSample,
    double weightGround,
    double size,
  ) {
    return EnzymeModel(
      enzyme: enzyme,
      variableA: variableA,
      variableB: variableB,
      duration: duration,
      weightSample: weightSample,
      weightGround: weightGround,
      size: size,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enzyme': enzyme,
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
      enzyme: map['enzyme'],
      variableA: map['variableA'],
      variableB: map['variableB'],
      duration: map['duration'],
      weightSample: map['weightSample'],
      weightGround: map['weightGround'],
      size: map['size'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EnzymeModel.fromJson(String source) =>
      EnzymeModel.fromMap(json.decode(source));
}
