// 📦 Package imports:
// 🌎 Project imports:
import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failure.dart';
import '../../../domain/entities/enzyme_entity.dart';
import '../enzymes_datasource.dart';

abstract class EnzymesDataSourceDecorator implements EnzymesDataSource {
  final EnzymesDataSource _enzymesDataSource;

  EnzymesDataSourceDecorator(this._enzymesDataSource);

  @override
  Future<Either<Failure, List<EnzymeEntity>>> getEnzymes() => _enzymesDataSource.getEnzymes();

  @override
  Future<Either<Failure, Unit>> deleteEnzyme(String id) => _enzymesDataSource.deleteEnzyme(id);

  @override
  Future<Either<Failure, Unit>> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) => _enzymesDataSource.createEnzyme(name: name, variableA: variableA, variableB: variableB, type: type);
}
