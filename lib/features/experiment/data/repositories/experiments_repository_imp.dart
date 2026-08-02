// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/entities/experiment_pagination_entity.dart';
import '../../domain/entities/experiment_result_entity.dart';
import '../../domain/entities/repetition_entity.dart';
import '../../domain/repositories/experiments_repository.dart';
import '../datasources/experiments_datasource.dart';

class ExperimentsRepositoryImp implements ExperimentsRepository {
  final ExperimentsDataSource _experimentsDataSource;

  ExperimentsRepositoryImp(this._experimentsDataSource);

  @override
  Future<Either<Failure, List<RepetitionEntity>>> getRepetitions({required String experimentId}) async {
    return await _experimentsDataSource.getRepetitions(experimentId: experimentId);
  }

  @override
  Future<Either<Failure, RepetitionEntity>> previewRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) async {
    return await _experimentsDataSource.previewRepetition(
      experimentId: experimentId,
      treatmentId: treatmentId,
      enzymeId: enzymeId,
      repetitionNumber: repetitionNumber,
      sample: sample,
      whiteSample: whiteSample,
    );
  }

  @override
  Future<Either<Failure, ExperimentEntity>> saveRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) async {
    return await _experimentsDataSource.saveRepetition(
      experimentId: experimentId,
      treatmentId: treatmentId,
      enzymeId: enzymeId,
      repetitionNumber: repetitionNumber,
      sample: sample,
      whiteSample: whiteSample,
    );
  }

  @override
  Future<Either<Failure, ExperimentEntity>> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    return await _experimentsDataSource.createExperiment(
      name: name,
      description: description,
      repetitions: repetitions,
      treatmentsIDs: treatmentsIDs,
      enzymes: enzymes,
    );
  }

  @override
  Future<Either<Failure, ExperimentEntity>> updateExperiment({
    required String experimentId,
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    return await _experimentsDataSource.updateExperiment(
      experimentId: experimentId,
      name: name,
      description: description,
      repetitions: repetitions,
      treatmentsIDs: treatmentsIDs,
      enzymes: enzymes,
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteExperiment(String id) async {
    return await _experimentsDataSource.deleteExperiment(id);
  }

  @override
  Future<Either<Failure, ExperimentEntity>> getExperimentById(String id) async {
    return await _experimentsDataSource.getExperimentById(id);
  }

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    return await _experimentsDataSource.getExperiments(
      page,
      orderBy: orderBy,
      ordering: ordering,
      limit: limit,
      finished: finished,
    );
  }

  @override
  Future<Either<Failure, ExperimentResultEntity>> getResult({required String experimentId}) async {
    return await _experimentsDataSource.getResult(experimentId: experimentId);
  }

  @override
  Future<Either<Failure, EnzymeEntity>> updateEnzymeFormula({
    required String experimentId,
    required String experimentEnzymeId,
    String? customFormulaCurve,
    String? customFormulaCalculation,
  }) async {
    return await _experimentsDataSource.updateEnzymeFormula(
      experimentId: experimentId,
      experimentEnzymeId: experimentEnzymeId,
      customFormulaCurve: customFormulaCurve,
      customFormulaCalculation: customFormulaCalculation,
    );
  }

  @override
  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity) async {
    return await _experimentsDataSource.storeExperimentsInCache(experimentPaginationEntity);
  }
}
