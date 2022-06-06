// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/models/auth_request_model.dart';
import 'package:enzitech_app/src/shared/models/user_model.dart';

abstract class IAuthService {
  Future<UserModel> auth(AuthRequestModel credential);
  Future<void> recoverPassword(String email);
}

class AuthService implements IAuthService {
  final DioClient client;

  AuthService(this.client);

  @override
  Future<UserModel> auth(AuthRequestModel credential) async {
    try {
      var res = await client.post(
        "/auth/login",
        data: credential.toJson(),
      );

      return UserModel.fromMap(jsonDecode(res.data));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> recoverPassword(String email) async {
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
