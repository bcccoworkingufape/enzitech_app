// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../dto/experiment_dto.dart';
import '../get_experiment_by_id_datasource.dart';

class GetExperimentByIdRemoteDataSourceImp
    implements GetExperimentByIdDataSource {
  final HttpService _httpService;
  GetExperimentByIdRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentEntity>> call(String id) async {
    try {
      var response =
          await _httpService.get(API.REQUEST_EXPERIMENTS_WITH_ID(id));

      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
