// 🌎 Project imports:
import 'dart:convert';

import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';

class ExperimentsService {
  final DioClient client;

  ExperimentsService(this.client);

  Future<List<EnzymeModel>> fetchEnzymes() async {
    try {
      List<EnzymeModel> experiments = [];
      var res = await client.get(
        "/enzymes",
      );

      res.data.forEach((experiment) {
        experiments.add(EnzymeModel.fromMap(experiment));
      });

      return experiments;
    } catch (e) {
      rethrow;
    }
  }

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
    List<String> processes,
    List<EnzymeModel> experimentsEnzymes,
  ) async {
    try {
      var a = experimentsEnzymes
          .map((enzyme) => enzyme.toJsonCreateExperiment(1, 0.123, 0.234, 0.5))
          .toList();

      // ignore: unused_local_variable
      var res = await client.post(
        "/experiments",
        data: {
          "name": name,
          "description": description,
          "repetitions": repetitions,
          "processes": json.encode(processes),
          "experimentsEnzymes": a,
        },
      );

      print(res.statusCode);
    } catch (e) {
      rethrow;
    }
  }
}
