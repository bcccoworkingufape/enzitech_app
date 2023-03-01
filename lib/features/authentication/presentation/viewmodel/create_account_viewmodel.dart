// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/create_account/create_account_usecase.dart';

class CreateAccountViewmodel extends ChangeNotifier {
  final CreateAccountUseCase _createAccountUseCase;

  CreateAccountViewmodel(
    this._createAccountUseCase,
  );

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
    var result = await _createAccountUseCase(
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
