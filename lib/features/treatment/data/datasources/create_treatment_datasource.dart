// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';

abstract class CreateTreatmentDataSource {
  Future<Either<Failure, Unit>> call({
    required String name,
    required String description,
  });
}
