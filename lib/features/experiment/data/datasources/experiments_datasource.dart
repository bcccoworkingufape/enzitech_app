// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../domain/entities/experiment_calculation_entity.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/entities/experiment_pagination_entity.dart';
import '../../domain/entities/experiment_result_entity.dart';

abstract class ExperimentsDataSource {
  Future<Either<Failure, ExperimentCalculationEntity>> calculateExperiment({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
  });

  Future<Either<Failure, ExperimentEntity>> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  });

  Future<Either<Failure, Unit>> deleteExperiment(String id);

  Future<Either<Failure, List<EnzymeEntity>>> getEnzymesRemainingInExperiment({
    required String experimentId,
    required String treatmentId,
  });

  Future<Either<Failure, ExperimentEntity>> getExperimentById(String id);

  Future<Either<Failure, ExperimentPaginationEntity>> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  });

  Future<Either<Failure, ExperimentResultEntity>> getResult({required String experimentId});

  Future<Either<Failure, ExperimentEntity>> saveResult({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
    required List<num> results,
    required num average,
  });

  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity);
}
