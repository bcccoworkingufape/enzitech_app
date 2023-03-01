// 🎯 Dart imports:

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../delete_treatment_datasource.dart';

class DeleteTreatmentRemoteDataSourceImp implements DeleteTreatmentDataSource {
  final HttpService _httpService;
  DeleteTreatmentRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    try {
      await _httpService.delete(API.REQUEST_TREATMENTS_WITH_ID(id));
      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
