// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/models_/enzyme_model.dart';

class EnzymesService {
  final DioClient client;

  EnzymesService(this.client);

  Future<List<EnzymeModel>> getEnzymes() async {
    try {
      List<EnzymeModel> enzymes = [];
      var res = await client.get(
        "/enzymes",
      );

      res.data.forEach((enzyme) {
        enzymes.add(EnzymeModel.fromMap(enzyme));
      });

      return enzymes;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createEnzyme(
    String name,
    double variableA,
    double variableB,
    String type,
  ) async {
    try {
      // ignore: unused_local_variable
      var res = await client.post(
        "/enzymes",
        data: {
          "name": name,
          "variableA": variableA,
          "variableB": variableB,
          "type": type
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEnzyme(
    String id,
  ) async {
    try {
      // ignore: unused_local_variable
      var res = await client.delete(
        "/enzymes/$id",
      );
    } catch (e) {
      rethrow;
    }
  }
}
