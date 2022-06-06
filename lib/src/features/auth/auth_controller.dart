// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/auth_request_model.dart';
import 'package:enzitech_app/src/shared/services/auth_service.dart';

enum AuthState { idle, success, error, loading }

class AuthController extends ChangeNotifier {
  final DioClient client;

  AuthController(this.client);

  var state = AuthState.idle;

  var authRequest = AuthRequestModel('', '');

  String? _user;
  String? get user => _user;
  void setUser(String user) {
    _user = user;
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
    // await Future.delayed(const Duration(seconds: 2));
    try {
      var authService = AuthService(client);

      var credential = AuthRequestModel.fromMap({
        'email': _user!.trim(),
        'password': _password!.trim(),
      });

      final response = await authService.auth(credential);

      // TODO: Store the response

      state = AuthState.success;
      notifyListeners();
    } on Failure catch (failure) {
      _setFailure(ServerFailure(message: failure.message));
      state = AuthState.error;
      notifyListeners();
    } catch (e) {
      _setFailure(UnknownError());
      state = AuthState.error;
      notifyListeners();
    }
  }
}
