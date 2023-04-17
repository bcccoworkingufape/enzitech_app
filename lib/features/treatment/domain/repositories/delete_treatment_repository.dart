// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';

abstract class DeleteTreatmentRepository {
  Future<Either<Failure, Unit>> call(String id);
}
