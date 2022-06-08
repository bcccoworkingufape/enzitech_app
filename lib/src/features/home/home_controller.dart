// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';

enum HomeState { idle, success, error, loading }

class HomeController extends ChangeNotifier {
  final DioClient client;

  HomeController(this.client);

  var state = HomeState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  Future<void> fetchExperiments(
    String term,
    int status,
  ) async {
    state = HomeState.loading;
    notifyListeners();
    try {
      // TODO: this
      // var authService = AuthService(client);

      // await authService.createUser(name, institution, email, password);

      await Future.delayed(const Duration(seconds: 5));

      state = HomeState.success;
      notifyListeners();
    } on Failure catch (failure) {
      _setFailure(ServerFailure(message: failure.message));
      state = HomeState.error;
      notifyListeners();
    } catch (e) {
      _setFailure(UnknownError());
      state = HomeState.error;
      notifyListeners();
    }
  }
}
