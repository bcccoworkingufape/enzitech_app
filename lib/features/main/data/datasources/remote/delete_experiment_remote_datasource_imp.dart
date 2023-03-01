// 🎯 Dart imports:

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_pagination_entity.dart';
import '../delete_experiment_datasource.dart';

class DeleteExperimentRemoteDataSourceImp
    implements DeleteExperimentDataSource {
  final HttpService _httpService;
  DeleteExperimentRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    try {
      await _httpService.delete(API.REQUEST_EXPERIMENTS_WITH_ID(id));

      // var result = response.statusCode == 200;

      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  /// Do not implement or use this method here!
  /// > If you want to use storeInCache do using the local repository
  @override
  Future<void> saveInCache(
      ExperimentPaginationEntity experimentPaginationEntity) {
    throw UnimplementedError();
  }
}
