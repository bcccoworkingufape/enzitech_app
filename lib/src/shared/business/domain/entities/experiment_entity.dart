// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/treatment_entity.dart';

class ExperimentEntity {
  String id;
  String name;
  String description;
  int repetitions;
  double progress;
  DateTime createdAt;
  DateTime updatedAt;
  List<TreatmentEntity>? treatments;
  List<EnzymeEntity>? enzymes;

  ExperimentEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.repetitions,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
    this.treatments,
    this.enzymes,
  });
}
