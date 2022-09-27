// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/user_model.dart';
import 'package:enzitech_app/src/shared/services/user_prefs_service.dart';

enum AccountState { idle, success, error, loading }

class AccountController extends ChangeNotifier {
  final UserPrefsServices userPrefsServices;

  AccountController(this.userPrefsServices);

  var state = AccountState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  UserModel? _user;
  UserModel? get user => _user;
  void _setUser(UserModel user) {
    _user = user;
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
    } catch (e) {
      _setFailure(e as Failure);
      state = AccountState.error;
      notifyListeners();
    }
  }

  Future<void> loadAccount() async {
    state = AccountState.loading;
    notifyListeners();
    try {
      await loadUser();

      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = AccountState.error;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    state = AccountState.loading;
    notifyListeners();
    try {
      String? user = await userPrefsServices.getFullUser();

      _setUser(
        UserModel.fromJson(
          jsonDecode(user!),
        ),
      );

      state = AccountState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = AccountState.error;
      notifyListeners();
    }
  }
}
