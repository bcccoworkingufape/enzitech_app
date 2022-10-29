// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_pagination_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/controllers/experiments_controller_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/experiments_repo.dart';
import 'package:enzitech_app/src/shared/ui/widgets/widgets.dart';

class ExperimentsController implements IExperimentsController {
  final ExperimentsRepo experimentsRepo;

  ExperimentsController({
    required this.experimentsRepo,
  });

  @override
  Future<ExperimentPaginationEntity> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    return experimentsRepo.getExperiments(
      page,
      orderBy: orderBy,
      ordering: ordering,
      limit: limit,
      finished: finished,
    );
  }

  @override
  Future<ExperimentEntity> getExperimentDetailed(String id) async {
    return experimentsRepo.getExperimentDetailed(id);
  }

  @override
  Future<ExperimentEntity> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> processes,
    required List<EnzymeEntity> experimentsEnzymes,
    required Map<String, EZTTextField> textFieldsOfEnzymes,
  }) async {
    return experimentsRepo.createExperiment(
      name: name,
      description: description,
      repetitions: repetitions,
      processes: processes,
      experimentsEnzymes: experimentsEnzymes,
      textFieldsOfEnzymes: textFieldsOfEnzymes,
    );
  }

  @override
  Future<void> calculateExperiment(Map<String, dynamic> jsonBody) async {
    return experimentsRepo.calculateExperiment(jsonBody);
  }

  @override
  Future<void> deleteExperiment(String id) async {
    return experimentsRepo.deleteExperiment(id);
  }
}
