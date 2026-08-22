// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../entities/experiment_entity.dart';
import '../entities/experiment_pagination_entity.dart';
import '../entities/experiment_result_entity.dart';
import '../entities/repetition_entity.dart';
import '../repositories/experiments_repository.dart';
import 'experiments_usecases.dart';

class ExperimentsUseCasesImp implements ExperimentsUseCases {
  final ExperimentsRepository _experimentsRepository;

  ExperimentsUseCasesImp(this._experimentsRepository);

  @override
  Future<Either<Failure, List<RepetitionEntity>>> getRepetitions({required String experimentId}) async {
    return await _experimentsRepository.getRepetitions(experimentId: experimentId);
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
    return await _experimentsRepository.previewRepetition(
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
    return await _experimentsRepository.saveRepetition(
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
    return await _experimentsRepository.createExperiment(
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
    return await _experimentsRepository.updateExperiment(
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
    return await _experimentsRepository.deleteExperiment(id);
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
  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity) async {
    return await _experimentsRepository.storeExperimentsInCache(experimentPaginationEntity);
  }
}
