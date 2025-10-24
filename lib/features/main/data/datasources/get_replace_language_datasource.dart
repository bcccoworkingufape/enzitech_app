// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';

abstract class GetReplaceLanguageDataSource {
  Future<Either<Failure, bool>> call();
}
