// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';

abstract class CreateTreatmentRepository {
  Future<Either<Failure, Unit>> call({
    required String name,
    required String description,
  });
}
