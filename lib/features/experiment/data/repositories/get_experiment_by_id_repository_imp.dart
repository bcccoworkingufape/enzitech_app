// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/repositories/get_experiment_by_id_repository.dart';
import '../datasources/get_experiment_by_id_datasource.dart';

class GetExperimentByIdRepositoryImp implements GetExperimentByIdRepository {
  final GetExperimentByIdDataSource _getExperimentByIdDataSource;

  GetExperimentByIdRepositoryImp(this._getExperimentByIdDataSource);

  @override
  Future<Either<Failure, ExperimentEntity>> call(String id) async {
    return await _getExperimentByIdDataSource(id);
  }
}
