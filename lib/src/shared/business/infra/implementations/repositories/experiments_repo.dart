// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_pagination_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/repositories/experiments_repo_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/business/infra/models/experiment_model.dart';
import 'package:enzitech_app/src/shared/business/infra/models/experiment_pagination_model.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/ui/widgets/widgets.dart';

class ExperimentsRepo implements IExperimentsRepo {
  final DioClient client;

  ExperimentsRepo(this.client);

  @override
  Future<ExperimentPaginationEntity> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    try {
      var addOrderBy = orderBy != null ? "&orderBy=$orderBy" : "";
      var addOrdering = ordering != null ? "&ordering=$ordering" : "";
      var addLimit = limit != null ? "&limit=$limit" : "";
      var addFinished = finished != null ? "&finished=$finished" : "";

      var res = await client.get(
        "/experiments?page=$page$addOrderBy$addOrdering$addLimit$addFinished",
      );

      return ExperimentPaginationModel.fromMap(res.data).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ExperimentEntity> getExperimentDetailed(
    String id,
  ) async {
    try {
      var res = await client.get(
        "/experiments/$id",
      );

      return ExperimentModel.fromMap(res.data).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ExperimentEntity> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> processes,
    required List<EnzymeEntity> experimentsEnzymes,
    required Map<String, EZTTextField> textFieldsOfEnzymes,
  }) async {
    try {
      var enzymes = experimentsEnzymes
          .map(
            (enzyme) => EnzymeModel.fromEntity(enzyme).toMapCreateExperiment(
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

      return ExperimentModel.fromMap(res.data).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> calculateExperiment(
    Map<String, dynamic> jsonBody,
  ) async {
    try {
      var res = await client.post(
        "/experiments",
        data: jsonBody,
      );

      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
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
