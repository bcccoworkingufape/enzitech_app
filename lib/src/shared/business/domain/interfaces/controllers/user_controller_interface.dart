// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/auth_request_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/user_entity.dart';

abstract class IUserController {
  Future<void> createUser({
    required String name,
    required String institution,
    required String email,
    required String password,
  });
}
