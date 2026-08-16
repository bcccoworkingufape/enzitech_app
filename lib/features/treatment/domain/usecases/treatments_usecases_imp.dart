// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../entities/treatment_entity.dart';
import '../repositories/treatments_repository.dart';
import 'treatments_usecases.dart';

class TreatmentsUseCasesImp implements TreatmentsUseCases {
  final TreatmentsRepository _treatmentsRepository;

  TreatmentsUseCasesImp(this._treatmentsRepository);

  @override
  Future<Either<Failure, TreatmentEntity>> createTreatment({required String name, required String description}) async {
    return await _treatmentsRepository.createTreatment(name: name, description: description);
  }

  @override
  Future<Either<Failure, Unit>> deleteTreatment(String id) async {
    return await _treatmentsRepository.deleteTreatment(id);
  }

  @override
  Future<Either<Failure, List<TreatmentEntity>>> getTreatments() async {
    return await _treatmentsRepository.getTreatments();
  }
}
