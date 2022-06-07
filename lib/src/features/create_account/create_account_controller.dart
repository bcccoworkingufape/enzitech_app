// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/services/auth_service.dart';

enum CreateAccountState { idle, success, error, loading }

class CreateAccountController extends ChangeNotifier {
  final DioClient client;

  CreateAccountController(this.client);

  var state = CreateAccountState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  Future<void> createUser(
    String name,
    String institution,
    String email,
    String password,
  ) async {
    state = CreateAccountState.loading;
    notifyListeners();
    try {
      var authService = AuthService(client);

      await authService.createUser(name, institution, email, password);

      state = CreateAccountState.success;
      notifyListeners();
    } on Failure catch (failure) {
      _setFailure(ServerFailure(message: failure.message));
      state = CreateAccountState.error;
      notifyListeners();
    } catch (e) {
      _setFailure(UnknownError());
      state = CreateAccountState.error;
      notifyListeners();
    }
  }
}
