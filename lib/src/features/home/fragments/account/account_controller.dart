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

  String? _username;
  String? get username => _username;
  void _setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  String? _email;
  String? get email => _email;
  void _setEmail(String email) {
    _email = email;
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

  Future<void> loadAccount() async {
    state = AccountState.loading;
    notifyListeners();
    try {
      await loadUsername();
      await loadEmail();

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

  Future<void> loadUsername() async {
    state = AccountState.loading;
    notifyListeners();
    try {
      UserPrefsServices userPrefsServices = UserPrefsServices();
      String username = await userPrefsServices.getName() ?? '';
      _setUsername(username);

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

  Future<void> loadEmail() async {
    state = AccountState.loading;
    notifyListeners();
    try {
      UserPrefsServices userPrefsServices = UserPrefsServices();
      String email = await userPrefsServices.getEmail() ?? '';
      _setEmail(email);

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
