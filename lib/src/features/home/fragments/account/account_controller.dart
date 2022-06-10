// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/services/user_prefs_service.dart';

enum AccountState { idle, success, error, loading }

class AccountController extends ChangeNotifier {
  final DioClient client;

  AccountController(this.client);

  var state = AccountState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  Future<void> logout() async {
    state = AccountState.loading;
    notifyListeners();
    try {
      UserPrefsServices userPrefsServices = UserPrefsServices();
      userPrefsServices.clearAll();

      state = AccountState.success;
      notifyListeners();
    } on Failure catch (failure) {
      _setFailure(ServerFailure(message: failure.message));
      state = AccountState.error;
      notifyListeners();
    } catch (e) {
      _setFailure(UnknownError());
      state = AccountState.error;
      notifyListeners();
    }
  }
}
