// 🌎 Project imports:
import '../../domain/entities/enzyme_entity.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/entities/treatment_entity.dart';
import '../dto/enzyme_dto.dart';
import '../dto/treatment_dto.dart';

extension ExperimentDto on ExperimentEntity {
  static ExperimentEntity fromJson(Map json) {
    return ExperimentEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      repetitions: json['repetitions'],
      progress: double.parse(json['progress']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      treatments: json['processes'] != null
          ? List<TreatmentEntity>.from(
              json['processes']?.map((x) => TreatmentDto.fromJson(x)))
          : null,
      enzymes: json['enzymes'] != null
          ? List<EnzymeEntity>.from(
              json['enzymes']?.map((x) => EnzymeDto.fromJson(x)))
          : null,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'repetitions': repetitions,
      'progress': progress,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'processes': treatments != null
          ? treatments!.map((x) => x.toJson()).toList()
          : null,
      'enzymes':
          enzymes != null ? enzymes!.map((x) => x.toJson()).toList() : null,
    };
  }
}
