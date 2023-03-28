// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../domain/repositories/get_enzymes_remaining_in_experiment_repository.dart';
import '../datasources/get_enzymes_remaining_in_experiment_datasource.dart';

class GetEnzymesRemainingInExperimentRepositoryImp
    implements GetEnzymesRemainingInExperimentRepository {
  final GetEnzymesRemainingInExperimentDataSource
      _getEnzymesRemainingInExperimentDataSource;

  GetEnzymesRemainingInExperimentRepositoryImp(
      this._getEnzymesRemainingInExperimentDataSource);

  @override
  Future<Either<Failure, List<EnzymeEntity>>> call({
    required String experimentId,
    required String treatmentId,
  }) async {
    return await _getEnzymesRemainingInExperimentDataSource(
      experimentId: experimentId,
      treatmentId: treatmentId,
    );
  }
}
