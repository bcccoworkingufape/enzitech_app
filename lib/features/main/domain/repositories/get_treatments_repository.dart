// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/treatment_entity.dart';

abstract class GetTreatmentsRepository {
  Future<Either<Failure, List<TreatmentEntity>>> call();
}
