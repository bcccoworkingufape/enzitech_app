import 'package:enzitech_app/src/shared/business/domain/interfaces/repositories/user_repo_interface.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/user_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/auth_request_entity.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';

class UserRepo implements IUserRepo {
  final DioClient client;

  UserRepo(this.client);

  @override
  Future<void> createUser(
    String name,
    String institution,
    String email,
    String password,
  ) async {
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
}
