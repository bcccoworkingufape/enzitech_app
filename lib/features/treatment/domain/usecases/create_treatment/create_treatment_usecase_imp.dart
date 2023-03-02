// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../repositories/create_treatment_repository.dart';
import 'create_treatment_usecase.dart';

class CreateTreatmentUseCaseImp implements CreateTreatmentUseCase {
  final CreateTreatmentRepository _createTreatmentRepository;

  CreateTreatmentUseCaseImp(this._createTreatmentRepository);

  @override
  Future<Either<Failure, Unit>> call({
    required String name,
    required String description,
  }) async {
    return await _createTreatmentRepository.call(
      name: name,
      description: description,
    );
  }
}
