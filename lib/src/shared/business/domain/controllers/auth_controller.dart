// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/auth_request_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/user_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/controllers/auth_controller_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/auth_repo.dart';

class AuthController implements IAuthController {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
  });

  @override
  Future<UserEntity> login(AuthRequestEntity authRequestEntity) async {
    return authRepo.login(authRequestEntity);
  }
}
