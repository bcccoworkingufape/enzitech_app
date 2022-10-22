// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/services_/auth_service.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

enum RecoverPasswordState { idle, success, error, loading }

class RecoverPasswordController extends ChangeNotifier {
  final DioClient client;

  RecoverPasswordController(this.client);

  var state = RecoverPasswordState.idle;

  String? _email;
  String? get email => _email;
  void setEmail(String email) {
    _email = email;
  }

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
  }

  Future<void> recoverPassword() async {
    state = RecoverPasswordState.loading;
    notifyListeners();
    try {
      var authService = AuthService(client);

      await authService.recoverPassword(email!);

      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = RecoverPasswordState.error;
      notifyListeners();
    }
  }
}
