// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/services/auth_service.dart';

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
    } on Failure catch (failure) {
      _setFailure(ServerFailure(message: failure.message));
      state = RecoverPasswordState.error;
      notifyListeners();
    } catch (e) {
      _setFailure(UnknownError());
      state = RecoverPasswordState.error;
      notifyListeners();
    }
  }
}
