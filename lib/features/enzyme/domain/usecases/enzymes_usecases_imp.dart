// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../entities/enzyme_entity.dart';
import '../repositories/enzymes_repository.dart';
import 'enzymes_usecases.dart';

class EnzymesUseCasesImp implements EnzymesUseCases {
  final EnzymesRepository _enzymesRepository;

  EnzymesUseCasesImp(this._enzymesRepository);

  @override
  Future<Either<Failure, Unit>> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) async {
    return await _enzymesRepository.createEnzyme(name: name, variableA: variableA, variableB: variableB, type: type);
  }

  @override
  Future<Either<Failure, Unit>> deleteEnzyme(String id) async {
    return await _enzymesRepository.deleteEnzyme(id);
  }

  @override
  Future<Either<Failure, List<EnzymeEntity>>> getEnzymes() async {
    return await _enzymesRepository.getEnzymes();
  }
}
