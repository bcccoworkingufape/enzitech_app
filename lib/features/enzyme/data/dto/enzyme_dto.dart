// 🌎 Project imports:
import '../../../../shared/extensions/extensions.dart';
import '../../domain/entities/enzyme_entity.dart';

extension EnzymeDto on EnzymeEntity {
  static EnzymeEntity fromJson(Map json) {
    return EnzymeEntity(
      id: json['id'],
      name: json['name'],
      variableA: json['variableA'] is String
          ? double.parse(json['variableA']).toPrecision(5)
          : json['variableA'],
      variableB: json['variableB'] is String
          ? double.parse(json['variableB']).toPrecision(5)
          : json['variableB'],
      type: json['type'],
      formula: json['formula'] ?? 'Fórmula não informada',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      duration: json['duration'] != null ? int.parse(json['duration']) : null,
      weightSample: json['weightSample'] != null
          ? double.parse(json['weightSample']).toPrecision(5)
          : null,
      weightGround: json['weightGround'] != null
          ? double.parse(json['weightGround']).toPrecision(5)
          : null,
      size: json['size'] != null
          ? double.parse(json['size']).toPrecision(5)
          : null,
    );
  }

  static EnzymeEntity toExperimetEnzyme(
    EnzymeEntity initialEnzyme, {
    required int duration,
    required double weightSample,
    required double weightGround,
    required double size,
  }) {
    return EnzymeEntity(
      id: initialEnzyme.id,
      name: initialEnzyme.name,
      variableA: initialEnzyme.variableA,
      variableB: initialEnzyme.variableB,
      type: initialEnzyme.type,
      formula: initialEnzyme.formula,
      createdAt: initialEnzyme.createdAt,
      updatedAt: initialEnzyme.updatedAt,
      duration: duration,
      weightSample: weightSample,
      weightGround: weightGround,
      size: size,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'variableA': variableA,
      'variableB': variableB,
      'type': type,
      'formula': formula,
      'updatedAt': updatedAt?.toString(),
      'createdAt': createdAt?.toString(),
      'duration': duration,
      'weightSample': weightSample,
      'weightGround': weightGround,
      'size': size,
    };
  }

  Map toJsonAsExperimentEnzyme() {
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
}
