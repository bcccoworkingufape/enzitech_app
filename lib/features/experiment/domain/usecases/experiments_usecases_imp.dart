// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../entities/experiment_calculation_entity.dart';
import '../entities/experiment_entity.dart';
import '../entities/experiment_pagination_entity.dart';
import '../entities/experiment_result_entity.dart';
import '../repositories/experiments_repository.dart';
import 'experiments_usecases.dart';

class ExperimentsUseCasesImp implements ExperimentsUseCases {
  final ExperimentsRepository _experimentsRepository;

  ExperimentsUseCasesImp(this._experimentsRepository);

  @override
  Future<Either<Failure, ExperimentCalculationEntity>> calculateExperiment({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
  }) async {
    return await _experimentsRepository.calculateExperiment(
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
    return await _experimentsRepository.createExperiment(
      name: name,
      description: description,
      repetitions: repetitions,
      treatmentsIDs: treatmentsIDs,
      enzymes: enzymes,
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteExperiment(String id) async {
    return await _experimentsRepository.deleteExperiment(id);
  }

  @override
  Future<Either<Failure, List<EnzymeEntity>>> getEnzymesRemainingInExperiment({
    required String experimentId,
    required String treatmentId,
  }) async {
    return await _experimentsRepository.getEnzymesRemainingInExperiment(
      experimentId: experimentId,
      treatmentId: treatmentId,
    );
  }

  @override
  Future<Either<Failure, ExperimentEntity>> getExperimentById(String id) async {
    return await _experimentsRepository.getExperimentById(id);
  }

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    return await _experimentsRepository.getExperiments(
      page,
      orderBy: orderBy,
      ordering: ordering,
      limit: limit,
      finished: finished,
    );
  }

  @override
  Future<Either<Failure, ExperimentResultEntity>> getResult({required String experimentId}) async {
    return await _experimentsRepository.getResult(experimentId: experimentId);
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
    return await _experimentsRepository.saveResult(
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
    return await _experimentsRepository.storeExperimentsInCache(experimentPaginationEntity);
  }
}
