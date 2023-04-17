// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/repositories/create_experiment_repository.dart';
import '../datasources/create_experiment_datasource.dart';

class CreateExperimentRepositoryImp implements CreateExperimentRepository {
  final CreateExperimentDataSource _createExperimentDataSource;

  CreateExperimentRepositoryImp(this._createExperimentDataSource);

  @override
  Future<Either<Failure, ExperimentEntity>> call({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    return await _createExperimentDataSource(
      name: name,
      description: description,
      repetitions: repetitions,
      treatmentsIDs: treatmentsIDs,
      enzymes: enzymes,
    );
  }
}
