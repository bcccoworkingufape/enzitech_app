// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';

abstract class CreateTreatmentUseCase {
  Future<Either<Failure, Unit>> call({
    required String name,
    required String description,
  });
}
