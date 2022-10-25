// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/interfaces/controllers/user_controller_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/user_repo.dart';

class UserController implements IUserController {
  final UserRepo userRepo;

  UserController({
    required this.userRepo,
  });

  @override
  Future<void> createUser({
    required String name,
    required String institution,
    required String email,
    required String password,
  }) async {
    return userRepo.createUser(
      name: name,
      institution: institution,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> recoverPassword({required String email}) async {
    return userRepo.recoverPassword(
      email: email,
    );
  }
}
