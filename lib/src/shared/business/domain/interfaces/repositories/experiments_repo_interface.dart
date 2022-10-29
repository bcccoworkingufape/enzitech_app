// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_pagination_entity.dart';
import 'package:enzitech_app/src/shared/ui/widgets/widgets.dart';

abstract class IExperimentsRepo {
  Future<ExperimentPaginationEntity> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  });

  Future<ExperimentEntity> getExperimentDetailed(
    String id,
  );

  Future<ExperimentEntity> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> processes,
    required List<EnzymeEntity> experimentsEnzymes,
    required Map<String, EZTTextField> textFieldsOfEnzymes,
  });
  Future<void> calculateExperiment(
    Map<String, dynamic> jsonBody,
  );
  Future<void> deleteExperiment(
    String id,
  );
}
