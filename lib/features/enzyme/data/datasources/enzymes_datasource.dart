// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/failures/failures.dart';
import '../../domain/entities/enzyme_entity.dart';

abstract class EnzymesDataSource {

  Future<Either<Failure, Unit>> deleteEnzyme(String id);

  Future<Either<Failure, Unit>> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  });

  Future<Either<Failure, List<EnzymeEntity>>> getEnzymes();
}