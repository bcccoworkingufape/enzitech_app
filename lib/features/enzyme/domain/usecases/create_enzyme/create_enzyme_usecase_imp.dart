// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../repositories/create_enzyme_repository.dart';
import 'create_enzyme_usecase.dart';

class CreateEnzymeUseCaseImp implements CreateEnzymeUseCase {
  final CreateEnzymeRepository _createEnzymeRepository;

  CreateEnzymeUseCaseImp(this._createEnzymeRepository);

  @override
  Future<Either<Failure, Unit>> call({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) async {
    return await _createEnzymeRepository.call(
      name: name,
      variableA: variableA,
      variableB: variableB,
      type: type,
    );
  }
}
