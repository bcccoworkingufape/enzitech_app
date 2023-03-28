// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failures.dart';
import '../../../../../shared/utils/utils.dart';
import '../../../../enzyme/data/dto/enzyme_dto.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../get_enzymes_remaining_in_experiment_datasource.dart';

class GetEnzymesRemainingInExperimentRemoteDataSourceImp
    implements GetEnzymesRemainingInExperimentDataSource {
  final HttpService _httpService;
  GetEnzymesRemainingInExperimentRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, List<EnzymeEntity>>> call({
    required String experimentId,
    required String treatmentId,
  }) async {
    try {
      var response = await _httpService.post(
          API.REQUEST_ENZYMES_REMAINING_IN_EXPERIMENT(experimentId),
          data: {
            "process": treatmentId,
          });

      var result = (response.data["enzymes"] as List)
          .map(
            (e) => EnzymeDto.fromJson(e),
          )
          .toList();

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
