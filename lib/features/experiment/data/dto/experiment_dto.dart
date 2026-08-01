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
      // Lê de `experimentEnzymes`, não de `enzymes`: é o único campo que traz, junto do
      // snapshot da enzima, a configuração (duração, peso, volume, variáveis) já salva
      // para este experimento — necessário para pré-preencher a tela de edição.
      enzymes: json['experimentEnzymes'] != null
          ? List<EnzymeEntity>.from(
              (json['experimentEnzymes'] as List).map((x) {
                final enzyme = EnzymeDto.fromJson(x['enzyme']);
                return EnzymeEntity(
                  id: enzyme.id,
                  sourceEnzymeId: enzyme.sourceEnzymeId,
                  name: enzyme.name,
                  variableA: safeDouble(x['variableA']),
                  variableB: safeDouble(x['variableB']),
                  type: enzyme.type,
                  formula: enzyme.formula,
                  createdAt: enzyme.createdAt,
                  updatedAt: enzyme.updatedAt,
                  duration: x['duration'] != null ? double.tryParse(x['duration'].toString())?.round() : null,
                  weightSample: x['weightSample'] != null ? double.tryParse(x['weightSample'].toString()) : null,
                  weightGround: x['weightGround'] != null ? double.tryParse(x['weightGround'].toString()) : null,
                  size: x['size'] != null ? double.tryParse(x['size'].toString()) : null,
                );
              }),
            )
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