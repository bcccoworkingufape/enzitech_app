// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';

abstract class CreateEnzymeRepository {
  Future<Either<Failure, Unit>> call({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  });
}
