// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../entities/experiment_entity.dart';

abstract class CreateExperimentRepository {
  Future<Either<Failure, ExperimentEntity>> call({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  });
}
