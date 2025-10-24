// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';

abstract class GetReplaceLanguageRepository {
  Future<Either<Failure, bool>> call();
}
