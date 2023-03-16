// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_calculation_entity.dart';
import '../../dto/experiment_calculation_dto.dart';
import '../calculate_experiment_datasource.dart';

class CalculateExperimentRemoteDataSourceImp
    implements CalculateExperimentDataSource {
  final HttpService _httpService;
  CalculateExperimentRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentCalculationEntity>> call({
    required String enzymeId,
    required String treatmentID,
    required Map<String, dynamic> experimentData,
  }) async {
    try {
      var response = await _httpService.post(
        API.REQUEST_EXPERIMENTS,
        data: {
          "enzyme": enzymeId,
          "process": treatmentID,
          "experimentData": experimentData,
        },
      );

      var result = ExperimentCalculationDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
