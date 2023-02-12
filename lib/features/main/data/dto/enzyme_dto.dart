// 🌎 Project imports:
import '../../../../shared/extensions/extensions.dart';
import '../../domain/entities/enzyme_entity.dart';

extension EnzymeDto on EnzymeEntity {
  static EnzymeEntity fromJson(Map json) {
    return EnzymeEntity(
      id: json['id'],
      name: json['name'],
      variableA: json['variableA'] is String
          ? double.parse(json['variableA']).toPrecision(3)
          : json['variableA'],
      variableB: json['variableB'] is String
          ? double.parse(json['variableB']).toPrecision(3)
          : json['variableB'],
      type: json['type'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'variableA': variableA,
      'variableB': variableB,
      'type': type,
      'updatedAt': updatedAt?.toString(),
      'createdAt': createdAt?.toString(),
    };
  }
}
