// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../domain/entities/experiment_calculation_entity.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/entities/experiment_pagination_entity.dart';
import '../../domain/entities/experiment_result_entity.dart';
import '../../domain/repositories/experiments_repository.dart';
import '../datasources/experiments_datasource.dart';

class ExperimentsRepositoryImp implements ExperimentsRepository {
  final ExperimentsDataSource _experimentsDataSource;

  ExperimentsRepositoryImp(this._experimentsDataSource);

  @override
  Future<Either<Failure, ExperimentCalculationEntity>> calculateExperiment({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
  }) async {
    return await _experimentsDataSource.calculateExperiment(
      experimentId: experimentId,
      enzymeId: enzymeId,
      treatmentID: treatmentID,
      listOfExperimentData: listOfExperimentData,
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
  Future<Either<Failure, Unit>> deleteExperiment(String id) async {
    return await _experimentsDataSource.deleteExperiment(id);
  }

  @override
  Future<Either<Failure, List<EnzymeEntity>>> getEnzymesRemainingInExperiment({
    required String experimentId,
    required String treatmentId,
  }) async {
    return await _experimentsDataSource.getEnzymesRemainingInExperiment(
      experimentId: experimentId,
      treatmentId: treatmentId,
    );
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
  Future<Either<Failure, ExperimentEntity>> saveResult({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
    required List<num> results,
    required num average,
  }) async {
    return await _experimentsDataSource.saveResult(
      experimentId: experimentId,
      enzymeId: enzymeId,
      treatmentID: treatmentID,
      listOfExperimentData: listOfExperimentData,
      results: results,
      average: average,
    );
  }

  @override
  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity) async {
    return await _experimentsDataSource.storeExperimentsInCache(experimentPaginationEntity);
  }
}
