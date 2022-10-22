import 'package:enzitech_app/src/shared/business/domain/entities/auth_request_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/user_entity.dart';

abstract class IAuthController {
  Future<UserEntity> login(AuthRequestEntity authRequestEntity);
}
