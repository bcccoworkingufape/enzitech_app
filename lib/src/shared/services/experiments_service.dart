// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';

class ExperimentsService {
  final DioClient client;

  ExperimentsService(this.client);

  Future<List<ExperimentModel>> fetchExperiments() async {
    try {
      List<ExperimentModel> experiments = [];
      var res = await client.get(
        "/experiments",
      );

      res.data["experiments"].forEach((experiment) {
        experiments.add(ExperimentModel.fromMap(experiment));
      });

      return experiments;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createExperiment(
    String name,
    String description,
    int repetitions,
    // List<String> processes,
    // List<EnzymeModel> experimentsEnzymes,
  ) async {
    try {
      // ignore: unused_local_variable
      var res = await client.post(
        "/experiments",
        data: {
          "name": name,
          "description": description,
          "repetitions": repetitions,
          "processes": [
            "25a243db-1008-4268-a08b-efb7429f6bfa",
            "123a243db-2153-4268-a08b-efb7429f6bfa "
          ],
          "experimentsEnzymes": [
            {
              "enzyme": "25a243db-1008-4268-a08b-efb7429f6bfa",
              "variableA": 0.452,
              "variableB": 1.642,
              "duration": 1,
              "weightSample": 0.37,
              "weightGround": 0.59,
              "size": 1.642
            }
          ]
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
