// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../domain/entities/treatment_entity.dart';

abstract class GetTreatmentsDataSource {
  Future<Either<Failure, List<TreatmentEntity>>> call();
}
