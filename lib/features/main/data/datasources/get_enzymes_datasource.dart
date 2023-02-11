import 'package:dartz/dartz.dart';
import '../../domain/entities/enzyme_entity.dart';

import '../../../../core/failures/failures.dart';

abstract class GetEnzymesDataSource {
  Future<Either<Failure, List<EnzymeEntity>>> call();
}
