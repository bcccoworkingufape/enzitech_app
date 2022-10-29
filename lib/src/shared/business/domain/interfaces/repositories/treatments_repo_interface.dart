// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/treatment_entity.dart';

abstract class ITreatmentsRepo {
  Future<List<TreatmentEntity>> getTreatments();
  Future<void> createTreatment({
    required String name,
    required String description,
  });
  Future<void> deleteTreatment(
    String id,
  );
}
