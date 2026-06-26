// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/treatment_entity.dart';
import '../../dto/treatment_dto.dart';
import '../treatments_datasource.dart';

class TreatmentsRemoteDataSourceImp implements TreatmentsDataSource {
  final HttpService _httpService;
  TreatmentsRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, Unit>> deleteTreatment(String id) async {
    try {
      await _httpService.delete(API.REQUEST_TREATMENTS_WITH_ID(id));
      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, List<TreatmentEntity>>> getTreatments() async {
    try {
      var response = await _httpService.get(API.REQUEST_TREATMENTS);
      var result = (response.data as List).map((e) => TreatmentDto.fromJson(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> createTreatment({required String name, required String description}) async {
    try {
      await _httpService.post(API.REQUEST_TREATMENTS, data: {"name": name, "description": description});

      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
