// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/repositories/enzymes_repo_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';

class EnzymesRepo implements IEnzymesRepo {
  final DioClient client;

  EnzymesRepo(this.client);

  @override
  Future<List<EnzymeEntity>> getEnzymes() async {
    try {
      var res = await client.get(
        "/enzymes",
      );

      return (res.data as List)
          .map(
            (e) => EnzymeModel.fromMap(e).toEntity(),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) async {
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

  @override
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
