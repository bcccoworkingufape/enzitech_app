// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../entities/experiment_entity.dart';
import '../entities/experiment_pagination_entity.dart';
import '../entities/experiment_result_entity.dart';
import '../entities/repetition_entity.dart';

abstract class ExperimentsRepository {
  Future<Either<Failure, List<RepetitionEntity>>> getRepetitions({required String experimentId});

  Future<Either<Failure, RepetitionEntity>> previewRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  });

  Future<Either<Failure, ExperimentEntity>> saveRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  });

  Future<Either<Failure, ExperimentEntity>> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  });

  Future<Either<Failure, ExperimentEntity>> updateExperiment({
    required String experimentId,
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  });

  Future<Either<Failure, Unit>> deleteExperiment(String id);

  Future<Either<Failure, ExperimentEntity>> getExperimentById(String id);

  Future<Either<Failure, ExperimentPaginationEntity>> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  });

  Future<Either<Failure, ExperimentResultEntity>> getResult({required String experimentId});

  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity);
}
