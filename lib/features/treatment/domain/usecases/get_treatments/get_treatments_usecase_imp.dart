// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../../../treatment/domain/entities/treatment_entity.dart';
import '../../repositories/get_treatments_repository.dart';
import 'get_treatments_usecase.dart';

class GetTreatmentsUseCaseImp implements GetTreatmentsUseCase {
  final GetTreatmentsRepository _getTreatmentsRepository;

  GetTreatmentsUseCaseImp(this._getTreatmentsRepository);

  @override
  Future<Either<Failure, List<TreatmentEntity>>> call() async {
    return await _getTreatmentsRepository.call();
  }
}
