// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/auth_request_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/user_entity.dart';

abstract class IAuthRepo {
  Future<UserEntity> login(AuthRequestEntity credential);
}
