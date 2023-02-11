// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/enzyme_entity.dart';

abstract class GetEnzymesRepository {
  Future<Either<Failure, List<EnzymeEntity>>> call();
}
