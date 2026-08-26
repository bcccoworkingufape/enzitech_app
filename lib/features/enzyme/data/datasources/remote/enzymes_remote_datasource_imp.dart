// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../core/failures/server_failures/server_failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/enzyme_entity.dart';
import '../../dto/enzyme_dto.dart';
import '../enzymes_datasource.dart';

class EnzymesRemoteDataSourceImp implements EnzymesDataSource {
  final HttpService _httpService;
  EnzymesRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, Unit>> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) async {
    try {
      await _httpService.post(
        API.REQUEST_ENZYMES,
        data: {"name": name, "variableA": variableA, "variableB": variableB, "type": type},
      );

      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEnzyme(String id) async {
    try {
      await _httpService.delete(API.REQUEST_ENZYMES_WITH_ID(id));
      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, List<EnzymeEntity>>> getEnzymes() async {
    try {
      var response = await _httpService.get(API.REQUEST_ENZYMES);
      List<dynamic> enzymesList = response.data['content'] ?? response.data;
      var result = enzymesList.map((e) => EnzymeDto.fromJson(e)).toList();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Falha não mapeada nas Enzimas: $e'));
    }
  }
}
