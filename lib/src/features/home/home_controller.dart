// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/components/experiment_card.dart';
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

  int _fragmentIndex = 0;
  int get fragmentIndex => _fragmentIndex;
  void setFragmentIndex(int fragmentIndex) {
    _fragmentIndex = fragmentIndex;
    notifyListeners();
  }

  //TODO: REMOVER ESTE TESTE
  List<ExperimentCard> get mockedList => _mockedList;

  //TODO: REMOVER ESTE TESTE
  void setMockedList(List<ExperimentCard> mockedList) {
    _mockedList = mockedList;
    notifyListeners();
  }

  //TODO: REMOVER ESTE TESTE
  List<ExperimentCard> _mockedList = [
    ExperimentCard(
      name: 'Experimento 1',
      modifiedAt: DateTime.now(),
      description:
          'Esta é uma descrição opcional muito grande de experimento, bem detalhado, com muitas linhas, onde será permitido no máximo quatro linhas...',
      progress: .55,
    ),
    ExperimentCard(
      name: 'Experimento 2',
      modifiedAt: DateTime.now(),
      description:
          'Esta é uma descrição opcional muito grande de experimento, bem detalhado, com muitas linhas, onde será permitido no máximo quatro linhas...',
      progress: .25,
    ),
    ExperimentCard(
      name: 'Experimento 3',
      modifiedAt: DateTime.now(),
      description:
          'Esta é uma descrição opcional muito grande de experimento, bem detalhado, com muitas linhas, onde será permitido no máximo quatro linhas...',
      progress: .01,
    ),
    ExperimentCard(
      name: 'Experimento 4',
      modifiedAt: DateTime.now(),
      description:
          'Esta é uma descrição opcional muito grande de experimento, bem detalhado, com muitas linhas, onde será permitido no máximo quatro linhas...',
      progress: .95,
    ),
  ];

  void onFragmentTapped(int index) {
    setFragmentIndex(index);
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
