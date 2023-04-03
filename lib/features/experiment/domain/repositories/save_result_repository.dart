// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/experiment_entity.dart';

abstract class SaveResultRepository {
  Future<Either<Failure, ExperimentEntity>> call({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
    required List<num> results,
    required num average,
  });
}
