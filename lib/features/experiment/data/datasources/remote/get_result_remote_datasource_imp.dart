// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_result_entity.dart';
import '../../dto/experiment_result_dto.dart';
import '../get_result_datasource.dart';

class GetResultRemoteDataSourceImp implements GetResultDataSource {
  final HttpService _httpService;
  GetResultRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentResultEntity>> call({
    required String experimentId,
  }) async {
    try {
      var response = await _httpService.get(
        API.REQUEST_GET_RESULT_EXPERIMENTS(experimentId),
      );

      var result = ExperimentResultDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
