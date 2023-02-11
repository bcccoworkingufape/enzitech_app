import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failures.dart';
import '../../entities/enzyme_entity.dart';

abstract class GetEnzymesUseCase {
  Future<Either<Failure, List<EnzymeEntity>>> call();
}
