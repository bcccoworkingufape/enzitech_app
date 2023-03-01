// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/delete_experiment_repository.dart';
import '../datasources/delete_experiment_datasource.dart';

class DeleteExperimentRepositoryImp implements DeleteExperimentRepository {
  final DeleteExperimentDataSource _deleteExperimentDataSource;

  DeleteExperimentRepositoryImp(this._deleteExperimentDataSource);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await _deleteExperimentDataSource(id);
  }
}
