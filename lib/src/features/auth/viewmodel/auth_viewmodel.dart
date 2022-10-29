// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/auth_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/implementations.dart';
import 'package:enzitech_app/src/shared/business/infra/models/auth_request_model.dart';
import 'package:enzitech_app/src/shared/business/infra/models/user_model.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class AuthViewmodel extends IDisposableProvider {
  final AuthController authController;

  AuthViewmodel({
    required this.authController,
  });

  StateEnum _state = StateEnum.idle;
  StateEnum get state => _state;
  void setStateEnum(StateEnum state) {
    _state = state;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure? failure) {
    _failure = failure;
  }

  String? _loggedName;
  String? get loggedName => _loggedName;
  void setLoggedName(String? loggedName) {
    _loggedName = loggedName;
  }

  String? _email;
  String? get email => _email;
  void setEmail(String? email) {
    _email = email;
  }

  String? _password;
  String? get password => _password;
  void setPassword(String? password) {
    _password = password;
  }

  Future<void> loginAction() async {
    setStateEnum(StateEnum.loading);
    try {
      // TODO: Melhorar
      var authRequestEntity = AuthRequestModel.fromMap({
        'email': _email!.trim(),
        'password': _password!.trim(),
      }).toEntity();

      final user = await authController.login(authRequestEntity);

      setLoggedName(user.name);
      UserPrefsServices userPrefsServices = UserPrefsServices();
      await userPrefsServices
          .saveFullUser(jsonEncode(UserModel.fromEntity(user).toJson()));
      await userPrefsServices.saveToken(user.token);
      await userPrefsServices.initConfirmationsEnabled();
      // await client.setConfig(enableGetToken: true);

      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  @override
  void disposeValues() {
    _setFailure(null);
    setStateEnum(StateEnum.idle);
    setLoggedName(null);
    setEmail(null);
    setPassword(null);
  }
}
