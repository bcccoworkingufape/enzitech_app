// 🌎 Project imports:
import '../../../enzyme/data/dto/enzyme_dto.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../treatment/data/dto/treatment_dto.dart';
import '../../../treatment/domain/entities/treatment_entity.dart';
import '../../domain/entities/experiment_entity.dart';

extension ExperimentDto on ExperimentEntity {
  static ExperimentEntity fromJson(Map json) {
    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ExperimentEntity(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sem nome',
      description: json['description']?.toString() ?? '',
      repetitions: json['repetitions'] is int ? json['repetitions'] : int.tryParse(json['repetitions']?.toString() ?? '0') ?? 0,
      progress: safeDouble(json['progress']),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now() : DateTime.now(),
      treatments: json['processes'] != null
          ? List<TreatmentEntity>.from(json['processes']?.map((x) => TreatmentDto.fromJson(x)))
          : null,
      enzymes: json['enzymes'] != null
          ? List<EnzymeEntity>.from(json['enzymes']?.map((x) => EnzymeDto.fromJson(x)))
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
      'processes': treatments?.map((x) => x.toJson()).toList(),
      'enzymes': enzymes?.map((x) => x.toJson()).toList(),
    };
  }
}