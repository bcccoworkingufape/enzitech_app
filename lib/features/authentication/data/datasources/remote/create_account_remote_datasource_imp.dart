// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../create_account_datasource.dart';

class CreateAccountRemoteDataSourceImp implements CreateAccountDataSource {
  final HttpService _httpService;

  CreateAccountRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, Unit>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _httpService.post(
        API.REQUEST_USERS,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
