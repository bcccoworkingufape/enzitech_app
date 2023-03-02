// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../create_enzyme_datasource.dart';

class CreateEnzymeRemoteDataSourceImp implements CreateEnzymeDataSource {
  final HttpService _httpService;
  CreateEnzymeRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, Unit>> call({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) async {
    try {
      await _httpService.post(
        API.REQUEST_ENZYMES,
        data: {
          "name": name,
          "variableA": variableA,
          "variableB": variableB,
          "type": type
        },
      );

      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
