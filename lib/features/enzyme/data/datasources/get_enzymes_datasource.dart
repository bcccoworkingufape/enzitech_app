// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../domain/entities/enzyme_entity.dart';

abstract class GetEnzymesDataSource {
  Future<Either<Failure, List<EnzymeEntity>>> call();
}
