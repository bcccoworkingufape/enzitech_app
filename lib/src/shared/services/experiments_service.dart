// 🌎 Project imports:
import 'dart:convert';

import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';

import '../widgets/ezt_textfield.dart';

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
    Map<String, EZTTextField> textFieldsOfEnzymes,
  ) async {
    try {
      var enzymes = experimentsEnzymes
          .map(
            (enzyme) => enzyme.toJsonCreateExperiment(
              int.parse(textFieldsOfEnzymes['duration-${enzyme.id}']!
                  .controller!
                  .text),
              double.parse(textFieldsOfEnzymes['weightSample-${enzyme.id}']!
                  .controller!
                  .text),
              double.parse(textFieldsOfEnzymes['weightGround-${enzyme.id}']!
                  .controller!
                  .text),
              double.parse(
                  textFieldsOfEnzymes['size-${enzyme.id}']!.controller!.text),
            ),
          )
          .toList();

      // ignore: unused_local_variable
      var res = await client.post(
        "/experiments",
        data: {
          "name": name,
          "description": description,
          "repetitions": repetitions,
          "processes": processes,
          "experimentsEnzymes": enzymes,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExperiment(
    String id,
  ) async {
    try {
      // ignore: unused_local_variable
      var res = await client.delete(
        "/experiments/$id",
      );
    } catch (e) {
      rethrow;
    }
  }
}
