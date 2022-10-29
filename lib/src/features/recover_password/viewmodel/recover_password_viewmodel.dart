// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/user_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class RecoverPasswordViewmodel extends IDisposableProvider {
  final UserController userController;

  RecoverPasswordViewmodel({
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

  String? _email;
  String? get email => _email;
  void setEmail(String? email) {
    _email = email;
  }

  Future<void> recoverPassword() async {
    setStateEnum(StateEnum.loading);
    try {
      await userController.recoverPassword(
        email: email!,
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
    setEmail(null);
  }
}
