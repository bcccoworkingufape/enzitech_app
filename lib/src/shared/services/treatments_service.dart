// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/models/treatment_model.dart';

class TreatmentsService {
  final DioClient client;

  TreatmentsService(this.client);

  Future<List<TreatmentModel>> fetchTreatments() async {
    try {
      List<TreatmentModel> treatments = [];
      var res = await client.get(
        "/processes",
      );

      res.data.forEach((experiment) {
        treatments.add(TreatmentModel.fromMap(experiment));
      });

      return treatments;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTreatment(
    String name,
    String description,
  ) async {
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
}
