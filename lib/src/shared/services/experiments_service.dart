// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';

abstract class IExperimentsService {
  Future<List<ExperimentModel>> fetchExperiments();
}

class ExperimentsService implements IExperimentsService {
  final DioClient client;

  ExperimentsService(this.client);

  @override
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
}
