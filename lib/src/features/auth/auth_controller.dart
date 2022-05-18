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

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  Future<void> loginAction() async {
    state = AuthState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    try {
      var authService = AuthService(client);

      var credential = AuthRequestModel.fromMap({
        'email': 'armsa@email.com.br',
        'password': '123',
      });

      final response = await authService.auth(credential);

      // final response2 = await client.get(
      //   'https://fakestoreapi.com/products/',
      // );

      // store the response

      state = AuthState.success;
      notifyListeners();
    } on ForbiddenFailure {
      _setFailure(ForbiddenFailure(message: "Acesso não autorizado."));

      state = AuthState.error;
      notifyListeners();
    } catch (e) {
      state = AuthState.error;
      notifyListeners();
    }
  }
}
