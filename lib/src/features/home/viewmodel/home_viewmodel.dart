// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/ui/fragments/account/viewmodel/account_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/enzymes/viewmodel/enzymes_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/viewmodel/experiments_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/treatments/viewmodel/treatments_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class HomeViewmodel extends IDisposableProvider {
  final AccountViewmodel accountViewmodel;
  final TreatmentsViewmodel treatmentsViewmodel;
  final EnzymesViewmodel enzymesViewmodel;
  final ExperimentsViewmodel experimentsViewmodel;

  HomeViewmodel({
    required this.treatmentsViewmodel,
    required this.enzymesViewmodel,
    required this.accountViewmodel,
    required this.experimentsViewmodel,
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

  int _fragmentIndex = 0;
  int get fragmentIndex => _fragmentIndex;
  void setFragmentIndex(int fragmentIndex) {
    _fragmentIndex = fragmentIndex;
    notifyListeners();
  }

  void onFragmentTapped(int index) {
    setFragmentIndex(index);
  }

  Future<void> getContent() async {
    setStateEnum(StateEnum.loading);

    await experimentsViewmodel.loadExperiments(1);
    await enzymesViewmodel.loadEnzymes();
    await treatmentsViewmodel.loadTreatments();
    await accountViewmodel.loadAccountFragment();

    if (experimentsViewmodel.state == StateEnum.error) {
      _setFailure(experimentsViewmodel.failure!);
      setStateEnum(StateEnum.error);
    } else if (treatmentsViewmodel.state == StateEnum.error) {
      _setFailure(treatmentsViewmodel.failure!);
      setStateEnum(StateEnum.error);
    } else if (enzymesViewmodel.state == StateEnum.error) {
      _setFailure(enzymesViewmodel.failure!);
      setStateEnum(StateEnum.error);
    } else if (accountViewmodel.state == StateEnum.error) {
      _setFailure(accountViewmodel.failure!);
      setStateEnum(StateEnum.error);
    } else {
      setStateEnum(StateEnum.success);
    }
  }

  @override
  void disposeValues() {
    setStateEnum(StateEnum.idle);
    _setFailure(null);
  }
}
