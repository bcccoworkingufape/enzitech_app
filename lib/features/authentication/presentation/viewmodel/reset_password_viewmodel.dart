// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/auth/auth_usecase.dart';

class ResetPasswordViewmodel extends ChangeNotifier {
  final AuthUseCase _authUseCase;

  ResetPasswordViewmodel(this._authUseCase);

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

  Future<void> resetPassword({required String email, required String token, required String newPassword}) async {
    setStateEnum(StateEnum.loading);

    var result = await _authUseCase.resetPassword(email: email, token: token, newPassword: newPassword);

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
