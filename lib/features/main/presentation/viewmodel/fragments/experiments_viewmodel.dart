// import 'package:enzitech_app/features/home/data/datasources/get_enzymes_datasource.dart';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/connection_checker/connection_checker.dart';
import '../../../../../core/enums/enums.dart';
import '../../../../../core/failures/failures.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../../domain/entities/experiment_pagination_entity.dart';
import '../../../domain/repositories/store_experiments_in_cache_repository.dart';
import '../../../domain/usecases/delete_experiment/delete_experiment_usecase.dart';
import '../../../domain/usecases/get_experiments/get_experiments_usecase.dart';

class ExperimentsViewmodel extends ChangeNotifier {
  final GetExperimentsUseCase _getExperimentsUseCase;
  final DeleteExperimentUseCase _deleteExperimentUseCase;

  final StoreExperimentsInCacheRepository _storeExperimentsInCacheRepository;
  final ConnectionChecker connectionChecker;

  ExperimentsViewmodel(
    this._getExperimentsUseCase,
    this._deleteExperimentUseCase,
    this._storeExperimentsInCacheRepository,
    this.connectionChecker,
  );

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

  fetch({int pagination = 1}) async {
    setStateEnum(StateEnum.loading);

    if (pagination == 1) {
      _setPage(1);
      _setExperiments([]);
    } else {
      _setIsLoadingMoreRunning(true);
    }

    var result = await _getExperimentsUseCase(
      pagination,
      orderBy: orderBy,
      ordering: ordering,
      limit: null, // disabled for now
      finished: finishedFilter,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        _addToExperiments(success.experiments);
        _setTotalOfExperiments(success.total);

        bool hasInternetConnection =
            await connectionChecker.hasInternetInternetConnection();

        if (hasNextPage &&
            success.experiments.isNotEmpty &&
            hasInternetConnection) {
          _setPage(page + 1);
        }

        if (success.experiments.isNotEmpty) {
          await _storeExperimentsInCacheRepository(
            ExperimentPaginationEntity(
              total: _totalOfExperiments,
              experiments: experiments,
            ),
          );
        }

        _setIsLoadingMoreRunning(false);
        setStateEnum(StateEnum.success);
      },
    );
  }

  Future<void> clearFilters() async {
    setStateEnum(StateEnum.loading);

    try {
      setLimit(null);
      setOrderBy(null);
      setOrdering(null);
      setFinishedFilter(false);
      await fetch(); //? Mudar isso

      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> deleteExperiment(String id) async {
    var result = await _deleteExperimentUseCase(id);

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        _setTotalOfExperiments(_totalOfExperiments - 1);
      },
    );
  }
}
