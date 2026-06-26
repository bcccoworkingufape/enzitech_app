// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';
import '../entities/treatment_entity.dart';

abstract class TreatmentsUseCases {
  Future<Either<Failure, Unit>> deleteTreatment(String id);

  Future<Either<Failure, Unit>> createTreatment({required String name, required String description});

  Future<Either<Failure, List<TreatmentEntity>>> getTreatments();
}
