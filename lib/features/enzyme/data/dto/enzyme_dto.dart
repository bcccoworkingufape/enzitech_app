// 🌎 Project imports:
import '../../../../shared/extensions/extensions.dart';
import '../../domain/entities/enzyme_entity.dart';

extension EnzymeDto on EnzymeEntity {
  static EnzymeEntity fromJson(Map json) {
    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value.toPrecision(5);
      if (value is int) return value.toDouble().toPrecision(5);
      if (value is String) return (double.tryParse(value) ?? 0.0).toPrecision(5);
      return 0.0;
    }

    return EnzymeEntity(
      id: json['id']?.toString() ?? '',
      sourceEnzymeId: json['sourceEnzymeId']?.toString(),
      name: json['name']?.toString() ?? 'Sem nome',
      variableA: safeDouble(json['variableA']),
      variableB: safeDouble(json['variableB']),
      type: json['type']?.toString() ?? 'Indefinido',
      formula: json['formula']?.toString() ?? json['formulaCalculation']?.toString() ?? 'Fórmula não informada',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      duration: json['duration'] != null ? double.tryParse(json['duration'].toString())?.round() : null,
      weightSample: json['weightSample'] != null ? double.tryParse(json['weightSample'].toString())?.toPrecision(5) : null,
      weightGround: json['weightGround'] != null ? double.tryParse(json['weightGround'].toString())?.toPrecision(5) : null,
      size: json['size'] != null ? double.tryParse(json['size'].toString())?.toPrecision(5) : null,
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
      sourceEnzymeId: initialEnzyme.sourceEnzymeId,
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