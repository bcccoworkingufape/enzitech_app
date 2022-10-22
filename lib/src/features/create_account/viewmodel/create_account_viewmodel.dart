// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/user_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class CreateAccountViewmodel extends IDisposableProvider {
  final UserController userController;

  CreateAccountViewmodel({
    required this.userController,
  });

  StateEnum _state = StateEnum.idle;
  StateEnum get state => _state;
  void setStateEnum(StateEnum state) {
    _state = state;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure? failure) {
    _failure = failure;
  }

  Future<void> createUser(
    String name,
    String institution,
    String email,
    String password,
  ) async {
    setStateEnum(StateEnum.loading);
    try {
      await userController.createUser(
        name: name,
        institution: institution,
        email: email,
        password: password,
      );

      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  @override
  void disposeValues() {
    setStateEnum(StateEnum.idle);
    _setFailure(null);
  }
}
