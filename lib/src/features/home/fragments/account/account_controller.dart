// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/user_model.dart';
import 'package:enzitech_app/src/shared/services/user_prefs_service.dart';
import 'package:enzitech_app/src/shared/util/util.dart';

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
  void _setUser(UserModel? user) {
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

      _setUser(null);
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

  Future<void> openUrl() async {
    try {
      if (!await launchUrl(Uri.parse(Constants.bccCoworkingLink))) {
        throw UnableToOpenURL(
            message:
                'Não foi possível acessar ${Uri.parse(Constants.bccCoworkingLink)}');
      }
    } on Exception catch (e) {
      _setFailure(e as Failure);
      state = AccountState.error;
      notifyListeners();
    }
  }
}
