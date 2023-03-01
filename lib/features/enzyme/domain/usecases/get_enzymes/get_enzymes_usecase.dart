// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';

abstract class GetEnzymesUseCase {
  Future<Either<Failure, List<EnzymeEntity>>> call();
}
