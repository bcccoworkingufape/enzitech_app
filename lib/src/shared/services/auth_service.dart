// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/models/auth_request_model.dart';
import 'package:enzitech_app/src/shared/models/user_model.dart';

abstract class IAuthService {
  Future<UserModel> auth(AuthRequestModel credential);
}

class AuthService implements IAuthService {
  final DioClient client;

  AuthService(this.client);

  @override
  Future<UserModel> auth(AuthRequestModel credential) async {
    try {
      var res = await client.post(
        "http://localhost:8080/auth",
        data: credential.toJson(),
      );

      return UserModel.fromMap(jsonDecode(res.data));
    } catch (e) {
      rethrow;
    }
  }
}
