// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/experiments_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class ExperimentsViewmodel extends IDisposableProvider {
  final ExperimentsController experimentsController;

  ExperimentsViewmodel({
    required this.experimentsController,
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

  // FILTER - FINISHED
  bool _finishedFilter = false;
  bool get finishedFilter => _finishedFilter;
  void setFinishedFilter(bool finishedFilter) {
    _finishedFilter = finishedFilter;
    notifyListeners();
  }

  // FILTER - ORDER BY
  String? _orderBy;
  String? get orderBy => _orderBy;
  void setOrderBy(String? orderBy) {
    _orderBy = orderBy;
    notifyListeners();
  }

  // FILTER - ORDERING
  String? _ordering;
  String? get ordering => _ordering;
  void setOrdering(String? ordering) {
    _ordering = ordering;
    notifyListeners();
  }

  // FILTER - LIMIT
  String? _limit;
  String? get limit => _limit;
  void setLimit(String? limit) {
    _limit = limit;
    notifyListeners();
  }

  int _page = 1;
  int get page => _page;
  void _setPage(int page) {
    _page = page;
    notifyListeners();
  }

  int _totalOfExperiments = 0;
  int get totalOfExperiments => _totalOfExperiments;
  void _setTotalOfExperiments(int totalOfExperiments) {
    _totalOfExperiments = totalOfExperiments;
    notifyListeners();
  }

  bool get hasNextPage => _experiments.isEmpty || _totalOfExperiments == 0
      ? false
      : (_totalOfExperiments % _experiments.length) > 0;

  bool _isLoadingMoreRunning = false;
  bool get isLoadingMoreRunning => _isLoadingMoreRunning;
  void _setIsLoadingMoreRunning(bool isLoadingMoreRunning) {
    _isLoadingMoreRunning = isLoadingMoreRunning;
    notifyListeners();
  }

  bool anyFilterIsEnabled() {
    if (limit != null || orderBy != null || ordering != null) {
      return true;
    }

    return false;
  }

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  List<ExperimentEntity> _experiments = [];
  List<ExperimentEntity> get experiments => _experiments;
  void _setExperiments(List<ExperimentEntity> experiments) {
    _experiments = experiments;
    notifyListeners();
  }

  void _addToExperiments(List<ExperimentEntity> experiments) {
    _experiments = _experiments + experiments;
    notifyListeners();
  }

  Future<void> loadExperiments(int page) async {
    setStateEnum(StateEnum.loading);

    try {
      if (page == 1) {
        _setPage(1);
        _setExperiments([]);
      } else {
        _setIsLoadingMoreRunning(true);
      }

      final experimentsWithPagination =
          await experimentsController.getExperiments(
        page,
        orderBy: orderBy,
        ordering: ordering,
        limit: null, // disabled for now
        finished: finishedFilter,
      );
      _addToExperiments(experimentsWithPagination.experiments);
      _setTotalOfExperiments(experimentsWithPagination.total);

      if (hasNextPage && experimentsWithPagination.experiments.isNotEmpty) {
        _setPage(page + 1);
      }

      setStateEnum(StateEnum.success);
      _setIsLoadingMoreRunning(false);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> clearFilters() async {
    setStateEnum(StateEnum.loading);

    try {
      setLimit(null);
      setOrderBy(null);
      setOrdering(null);
      setFinishedFilter(false);
      await loadExperiments(1); //? Mudar isso

      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> deleteExperiment(String id) async {
    //? Apagar para não notificar essa alteração
    setStateEnum(StateEnum.loading);
    try {
      await experimentsController.deleteExperiment(id);
      _setTotalOfExperiments(_totalOfExperiments - 1);

      //? Apagar para não notificar essa alteração
      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  @override
  void disposeValues() {
    setStateEnum(StateEnum.idle);
    _setFailure(null);
  }
}
