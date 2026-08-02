// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../../domain/entities/experiment_pagination_entity.dart';
import '../../../domain/entities/experiment_result_entity.dart';
import '../../../domain/entities/repetition_entity.dart';
import '../experiments_datasource.dart';

abstract class ExperimentsDataSourceDecorator implements ExperimentsDataSource {
  final ExperimentsDataSource _experimentsDataSource;

  ExperimentsDataSourceDecorator(this._experimentsDataSource);

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) => _experimentsDataSource.getExperiments(
    page,
    orderBy: orderBy,
    ordering: ordering,
    limit: limit,
    finished: finished,
  );

  @override
  Future<Either<Failure, List<RepetitionEntity>>> getRepetitions({required String experimentId}) =>
      _experimentsDataSource.getRepetitions(experimentId: experimentId);

  @override
  Future<Either<Failure, RepetitionEntity>> previewRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) => _experimentsDataSource.previewRepetition(
    experimentId: experimentId,
    treatmentId: treatmentId,
    enzymeId: enzymeId,
    repetitionNumber: repetitionNumber,
    sample: sample,
    whiteSample: whiteSample,
  );

  @override
  Future<Either<Failure, ExperimentEntity>> saveRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) => _experimentsDataSource.saveRepetition(
    experimentId: experimentId,
    treatmentId: treatmentId,
    enzymeId: enzymeId,
    repetitionNumber: repetitionNumber,
    sample: sample,
    whiteSample: whiteSample,
  );

  @override
  Future<Either<Failure, ExperimentEntity>> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) => _experimentsDataSource.createExperiment(
    name: name,
    description: description,
    repetitions: repetitions,
    treatmentsIDs: treatmentsIDs,
    enzymes: enzymes,
  );

  @override
  Future<Either<Failure, ExperimentEntity>> updateExperiment({
    required String experimentId,
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) => _experimentsDataSource.updateExperiment(
    experimentId: experimentId,
    name: name,
    description: description,
    repetitions: repetitions,
    treatmentsIDs: treatmentsIDs,
    enzymes: enzymes,
  );

  @override
  Future<Either<Failure, Unit>> deleteExperiment(String id) => _experimentsDataSource.deleteExperiment(id);

  @override
  Future<Either<Failure, ExperimentEntity>> getExperimentById(String id) =>
      _experimentsDataSource.getExperimentById(id);

  @override
  Future<Either<Failure, ExperimentResultEntity>> getResult({required String experimentId}) =>
      _experimentsDataSource.getResult(experimentId: experimentId);

  @override
  Future<Either<Failure, EnzymeEntity>> updateEnzymeFormula({
    required String experimentId,
    required String experimentEnzymeId,
    String? customFormulaCurve,
    String? customFormulaCalculation,
  }) => _experimentsDataSource.updateEnzymeFormula(
    experimentId: experimentId,
    experimentEnzymeId: experimentEnzymeId,
    customFormulaCurve: customFormulaCurve,
    customFormulaCalculation: customFormulaCalculation,
  );

  @override
  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity) =>
      _experimentsDataSource.storeExperimentsInCache(experimentPaginationEntity);
}
