// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';

abstract class GetEnzymesRemainingInExperimentRepository {
  Future<Either<Failure, List<EnzymeEntity>>> call({
    required String experimentId,
    required String treatmentId,
  });
}
