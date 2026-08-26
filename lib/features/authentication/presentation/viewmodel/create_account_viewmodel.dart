// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/auth/auth_usecase.dart';

class CreateAccountViewmodel extends ChangeNotifier {
  final AuthUseCase _authAccountUseCase;

  CreateAccountViewmodel(this._authAccountUseCase);

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

  Future<void> createUser(String name, String institution, String email, String password) async {
    setStateEnum(StateEnum.loading);
    var result = await _authAccountUseCase.createAccount(
      name: name.trim(),
      email: email.trim(),
      password: password.trim(),
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) {
        setStateEnum(StateEnum.success);
      },
    );
  }
}
