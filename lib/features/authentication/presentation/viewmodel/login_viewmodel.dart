// 🎯 Dart imports:
import 'dart:convert';
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../core/domain/service/http/http_service.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/login/login_usecase.dart';

// 🌎 Project imports:

class LoginViewmodel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginViewmodel(this._loginUseCase);

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

  String? _loggedName;
  String? get loggedName => _loggedName;
  void setLoggedName(String? loggedName) {
    _loggedName = loggedName;
  }

  String? _email;
  String? get email => _email;
  void setEmail(String? email) {
    _email = email;
  }

  String? _password;
  String? get password => _password;
  void setPassword(String? password) {
    _password = password;
  }

  Future<void> loginAction() async {
    setStateEnum(StateEnum.loading);
    var result = await _loginUseCase.call(
      email: email!.trim(),
      password: password!.trim(),
    );

    result.fold(
      (error) {
        _setFailure(error as Failure);
        setStateEnum(StateEnum.error);
      },
      (success) {
        GetIt.I.get<HttpService>().setConfig(token: success.token);
        setStateEnum(StateEnum.success);
      },
    );
  }
}
