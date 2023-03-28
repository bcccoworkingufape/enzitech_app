// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../dto/experiment_dto.dart';
import '../save_result_datasource.dart';

class SaveResultRemoteDataSourceImp implements SaveResultDataSource {
  final HttpService _httpService;
  SaveResultRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentEntity>> call({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<double> results,
    required double average,
  }) async {
    try {
      var response = await _httpService.post(
        API.REQUEST_SAVE_RESULT_EXPERIMENTS(experimentId),
        data: {
          "enzyme": enzymeId,
          "process": treatmentID,
          "results": results,
          "average": average
        },
      );
      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
