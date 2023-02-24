// 📦 Package imports:
import '../../repositories/clear_user_repository.dart';
import 'clear_user_usecase.dart';

class ClearUserUseCaseImp implements ClearUserUseCase {
  final ClearUserRepository _clearUserRepository;

  ClearUserUseCaseImp(this._clearUserRepository);

  @override
  Future<void> call() async {
    return await _clearUserRepository();
  }
}
