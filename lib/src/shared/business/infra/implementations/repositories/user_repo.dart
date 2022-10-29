// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/interfaces/repositories/user_repo_interface.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';

class UserRepo implements IUserRepo {
  final DioClient client;

  UserRepo(this.client);

  @override
  Future<void> createUser({
    required String name,
    required String institution,
    required String email,
    required String password,
  }) async {
    try {
      await client.post(
        "/users",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "institution": institution,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> recoverPassword({required String email}) async {
    try {
      await client.post(
        "/auth/send-recover-email",
        data: {
          "email": email,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
