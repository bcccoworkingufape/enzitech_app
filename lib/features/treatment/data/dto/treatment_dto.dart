// 🌎 Project imports:
import '../../domain/entities/treatment_entity.dart';

extension TreatmentDto on TreatmentEntity {
  static TreatmentEntity fromJson(Map json) {
    return TreatmentEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
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
      'description': description,
      'updatedAt': updatedAt?.toString(),
      'createdAt': createdAt?.toString(),
    };
  }
}
