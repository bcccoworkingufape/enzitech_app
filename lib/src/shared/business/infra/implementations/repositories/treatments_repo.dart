// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/treatment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/repositories/treatments_repo_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/models/treatment_model.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';

class TreatmentsRepo implements ITreatmentsRepo {
  final DioClient client;

  TreatmentsRepo(this.client);

  @override
  Future<List<TreatmentEntity>> getTreatments() async {
    try {
      var res = await client.get(
        "/processes",
      );

      return (res.data as List)
          .map(
            (e) => TreatmentModel.fromMap(e).toEntity(),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createTreatment({
    required String name,
    required String description,
  }) async {
    try {
      // ignore: unused_local_variable
      var res = await client.post(
        "/processes",
        data: {
          "name": name,
          "description": description,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTreatment(
    String id,
  ) async {
    try {
      // ignore: unused_local_variable
      var res = await client.delete(
        "/processes/$id",
      );
    } catch (e) {
      rethrow;
    }
  }
}
