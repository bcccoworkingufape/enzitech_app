// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/models_/experiment_model.dart';
import 'package:enzitech_app/src/shared/services_/experiments_service.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

enum ExperimentsState { idle, success, error, loading }

class ExperimentsController extends ChangeNotifier {
  final ExperimentsService experimentsService;

  ExperimentsController(this.experimentsService);

  var state = ExperimentsState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
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

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  List<ExperimentModel> _experiments = [];
  List<ExperimentModel> get experiments => _experiments;
  void _setExperiments(List<ExperimentModel> experiments) {
    _experiments = experiments;
    notifyListeners();
  }

  void _addToExperiments(List<ExperimentModel> experiments) {
    _experiments = _experiments + experiments;
    notifyListeners();
  }

  int _totalOfExperiments = 0;
  int get totalOfExperiments => _totalOfExperiments;
  void _setTotalOfExperiments(int totalOfExperiments) {
    _totalOfExperiments = totalOfExperiments;
    notifyListeners();
  }

  int _page = 1;
  int get page => _page;
  void _setPage(int page) {
    _page = page;
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

  Future<void> clearFilters() async {
    state = ExperimentsState.loading;
    notifyListeners();
    try {
      setLimit(null);
      setOrderBy(null);
      setOrdering(null);
      setFinishedFilter(false);
      await loadExperiments(1);

      state = ExperimentsState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = ExperimentsState.error;
      notifyListeners();
    }
  }

  Future<void> loadExperiments(int page) async {
    state = ExperimentsState.loading;
    notifyListeners();
    try {
      if (page == 1) {
        _setPage(1);
        _setExperiments([]);
      } else {
        _setIsLoadingMoreRunning(true);
      }

      final experimentsWithPagination = await experimentsService.getExperiments(
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

      state = ExperimentsState.success;
      _setIsLoadingMoreRunning(false);
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = ExperimentsState.error;
      notifyListeners();
    }
  }

  Future<void> deleteExperiment(String id) async {
    // state = ExperimentsState.loading;
    // notifyListeners();
    try {
      await experimentsService.deleteExperiment(id);
      _setTotalOfExperiments(_totalOfExperiments - 1);

      // state = ExperimentsState.success;
      // notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = ExperimentsState.error;
      notifyListeners();
    }
  }
}
