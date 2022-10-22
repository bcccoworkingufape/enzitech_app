// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';
import 'package:enzitech_app/src/shared/business/infra/models/auth_request_model.dart';
import 'package:enzitech_app/src/shared/services_/auth_service.dart';
import 'package:enzitech_app/src/shared/services_/user_prefs_service.dart';

enum AuthState { idle, success, error, loading }

class AuthController extends ChangeNotifier {
  final DioClient client;
  final AuthService authService;

  AuthController(this.client, this.authService);

  var state = AuthState.idle;

  var authRequest = AuthRequestModel(email: '', password: '');

  String? _loggedName;
  String? get loggedName => _loggedName;
  void setLoggedName(String loggedName) {
    _loggedName = loggedName;
  }

  String? _email;
  String? get email => _email;
  void setEmail(String email) {
    _email = email;
  }

  String? _password;
  String? get password => _password;
  void setPassword(String password) {
    _password = password;
  }

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
  }

  Future<void> loginAction() async {
    state = AuthState.loading;
    notifyListeners();
    try {
      var credential = AuthRequestModel.fromMap({
        'email': _email!.trim(),
        'password': _password!.trim(),
      });

      final response = await authService.auth(credential);

      setLoggedName(response.name);
      UserPrefsServices userPrefsServices = UserPrefsServices();
      await userPrefsServices.saveFullUser(jsonEncode(response));
      await userPrefsServices.saveToken(response.token);
      await userPrefsServices.initConfirmationsEnabled();
      await client.setConfig(token: response.token);

      state = AuthState.success;
    } catch (e) {
      _setFailure(e as Failure);
      state = AuthState.error;
    } finally {
      notifyListeners();
    }
  }
}
