// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/auth/auth_usecase.dart';

class RecoverPasswordViewmodel extends ChangeNotifier {
  final AuthUseCase _authUseCase;

  RecoverPasswordViewmodel(this._authUseCase);

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

  Future<void> recoverPassword(String email) async {
    setStateEnum(StateEnum.loading);

    var result = await _authUseCase.recoverPassword(email: email);

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
