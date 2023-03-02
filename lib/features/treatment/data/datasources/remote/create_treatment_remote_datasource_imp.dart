// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../create_treatment_datasource.dart';

class CreateTreatmentRemoteDataSourceImp implements CreateTreatmentDataSource {
  final HttpService _httpService;
  CreateTreatmentRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, Unit>> call({
    required String name,
    required String description,
  }) async {
    try {
      await _httpService.post(
        API.REQUEST_TREATMENTS,
        data: {
          "name": name,
          "description": description,
        },
      );

      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
