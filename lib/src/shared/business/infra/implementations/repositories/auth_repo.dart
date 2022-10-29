// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/auth_request_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/user_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/repositories/auth_repo_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/models/auth_request_model.dart';
import 'package:enzitech_app/src/shared/business/infra/models/user_model.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';

class AuthRepo implements IAuthRepo {
  final DioClient client;

  AuthRepo(this.client);

  @override
  Future<UserEntity> login(AuthRequestEntity credential) async {
    try {
      var res = await client.post(
        "/auth/login",
        data: AuthRequestModel.fromEntity(credential).toJson(),
      );

      await client.setConfig(token: res.data['accessToken']);

      return UserModel.fromMap(res.data).toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
