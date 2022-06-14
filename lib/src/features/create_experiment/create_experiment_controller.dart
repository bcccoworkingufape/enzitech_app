// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/services/auth_service.dart';

enum CreateExperimentState { idle, success, error, loading }

class CreateExperimentController extends ChangeNotifier {
  final DioClient client;

  CreateExperimentController(this.client);

  var state = CreateExperimentState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  Future<void> createExperiment(
    String name,
    String institution,
    String email,
    String password,
  ) async {
    state = CreateExperimentState.loading;
    notifyListeners();
    try {
      var authService = AuthService(client);

      await authService.createUser(name, institution, email, password);

      state = CreateExperimentState.success;
      notifyListeners();
    } on Failure catch (failure) {
      _setFailure(ServerFailure(message: failure.message));
      state = CreateExperimentState.error;
      notifyListeners();
    } catch (e) {
      _setFailure(UnknownError());
      state = CreateExperimentState.error;
      notifyListeners();
    }
  }
}
