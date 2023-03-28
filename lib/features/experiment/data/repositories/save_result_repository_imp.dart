// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/repositories/save_result_repository.dart';
import '../datasources/save_result_datasource.dart';

class SaveResultRepositoryImp implements SaveResultRepository {
  final SaveResultDataSource _saveResultDataSource;

  SaveResultRepositoryImp(this._saveResultDataSource);

  @override
  Future<Either<Failure, ExperimentEntity>> call({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<double> results,
    required double average,
  }) async {
    return await _saveResultDataSource(
      experimentId: experimentId,
      enzymeId: enzymeId,
      treatmentID: treatmentID,
      results: results,
      average: average,
    );
  }
}
