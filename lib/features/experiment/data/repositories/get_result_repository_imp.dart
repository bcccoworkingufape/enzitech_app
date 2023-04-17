// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/experiment_result_entity.dart';
import '../../domain/repositories/get_result_repository.dart';
import '../datasources/get_result_datasource.dart';

class GetResultRepositoryImp implements GetResultRepository {
  final GetResultDataSource _getResultDataSource;

  GetResultRepositoryImp(this._getResultDataSource);

  @override
  Future<Either<Failure, ExperimentResultEntity>> call({
    required String experimentId,
  }) async {
    return await _getResultDataSource(
      experimentId: experimentId,
    );
  }
}
