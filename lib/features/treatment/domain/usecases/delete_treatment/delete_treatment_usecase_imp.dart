// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../repositories/delete_treatment_repository.dart';
import 'delete_treatment_usecase.dart';

class DeleteTreatmentUseCaseImp implements DeleteTreatmentUseCase {
  final DeleteTreatmentRepository _deleteTreatmentRepository;

  DeleteTreatmentUseCaseImp(
    this._deleteTreatmentRepository,
  );

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await _deleteTreatmentRepository.call(id);
  }
}
