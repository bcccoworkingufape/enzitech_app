// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/enzyme_entity.dart';
import '../../domain/repositories/enzymes_repository.dart';
import '../datasources/enzymes_datasource.dart';

class EnzymesRepositoryImp implements EnzymesRepository {
  final EnzymesDataSource _enzymesDataSource;

  EnzymesRepositoryImp(this._enzymesDataSource);

  @override
  Future<Either<Failure, Unit>> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) async {
    return await _enzymesDataSource.createEnzyme(name: name, variableA: variableA, variableB: variableB, type: type);
  }

  @override
  Future<Either<Failure, Unit>> deleteEnzyme(String id) async {
    return await _enzymesDataSource.deleteEnzyme(id);
  }

  @override
  Future<Either<Failure, List<EnzymeEntity>>> getEnzymes() async {
    return await _enzymesDataSource.getEnzymes();
  }
}
