// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/treatment_entity.dart';

abstract class TreatmentsRepository {
  Future<Either<Failure, Unit>> deleteTreatment(String id);

  Future<Either<Failure, TreatmentEntity>> createTreatment({required String name, required String description});

  Future<Either<Failure, List<TreatmentEntity>>> getTreatments();
}
