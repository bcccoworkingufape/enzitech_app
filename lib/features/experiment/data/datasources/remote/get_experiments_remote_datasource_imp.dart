// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_pagination_entity.dart';
import '../../dto/experiment_pagination_dto.dart';
import '../get_experiments_datasource.dart';

class GetExperimentsRemoteDataSourceImp implements GetExperimentsDataSource {
  final HttpService _httpService;
  GetExperimentsRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> call(
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

      var response = await _httpService.get(
          '${API.REQUEST_EXPERIMENTS}?page=$page$addOrderBy$addOrdering$addLimit$addFinished');

      var result = ExperimentPaginationDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  /// Do not implement or use this method here!
  /// If you want to use storeInCache do using the local repository
  @override
  Future<void> saveInCache(
      ExperimentPaginationEntity experimentPaginationEntity) {
    throw UnimplementedError();
  }
}
