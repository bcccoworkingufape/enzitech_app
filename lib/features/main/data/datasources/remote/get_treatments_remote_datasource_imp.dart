// 🎯 Dart imports:
// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/treatment_entity.dart';
import '../../dto/treatment_dto.dart';
import '../get_treatments_datasource.dart';

class GetTreatmentsRemoteDataSourceImp implements GetTreatmentsDataSource {
  final HttpService _httpService;
  GetTreatmentsRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, List<TreatmentEntity>>> call() async {
    try {
      var response = await _httpService.get(API.REQUEST_TREATMENTS);
      var result = (response.data as List)
          .map(
            (e) => TreatmentDto.fromJson(e),
          )
          .toList();
      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
