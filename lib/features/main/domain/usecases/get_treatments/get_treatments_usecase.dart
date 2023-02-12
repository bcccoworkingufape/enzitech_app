// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';
import '../../entities/treatment_entity.dart';

abstract class GetTreatmentsUseCase {
  Future<Either<Failure, List<TreatmentEntity>>> call();
}
