// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';

abstract class DeleteEnzymeDataSource {
  Future<Either<Failure, Unit>> call(String id);
}
