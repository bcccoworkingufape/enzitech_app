// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/treatment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/controllers/treatments_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/treatments_repo.dart';

class TreatmentsController implements ITreatmentsController {
  final TreatmentsRepo treatmentsRepo;

  TreatmentsController({
    required this.treatmentsRepo,
  });

  @override
  Future<List<TreatmentEntity>> getTreatments() async {
    return treatmentsRepo.getTreatments();
  }

  @override
  Future<void> createTreatment({
    required String name,
    required String description,
  }) async {
    return treatmentsRepo.createTreatment(
      name: name,
      description: description,
    );
  }

  @override
  Future<void> deleteTreatment(String id) async {
    return treatmentsRepo.deleteTreatment(id);
  }
}
