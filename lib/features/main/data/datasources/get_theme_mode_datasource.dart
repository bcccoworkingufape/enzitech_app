// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';

abstract class GetThemeModeDataSource {
  Future<Either<Failure, String>> call();
}
