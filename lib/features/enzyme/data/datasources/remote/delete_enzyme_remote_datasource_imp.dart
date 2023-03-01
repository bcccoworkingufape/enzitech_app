// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../delete_enzyme_datasource.dart';

class DeleteEnzymeRemoteDataSourceImp implements DeleteEnzymeDataSource {
  final HttpService _httpService;
  DeleteEnzymeRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    try {
      await _httpService.delete(API.REQUEST_ENZYMES_WITH_ID(id));
      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
