// 🎯 Dart imports:
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:enzitech_app/features/main/presentation/ui/pages/home/fragments/treatments_page.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/fragments/account_viewmodel.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/fragments/enzymes_viewmodel.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/fragments/experiments_viewmodel.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/fragments/treatments_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../viewmodel/home_viewmodel.dart';
import 'fragments/account_page.dart';
import 'fragments/enzymes_page.dart';
import 'fragments/experiments_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final HomeViewmodel _homeViewmodel;
  late final AccountViewmodel _accountViewmodel;
  late final EnzymesViewmodel _enzymesViewmodel;
  late final ExperimentsViewmodel _experimentsViewmodel;
  late final TreatmentsViewmodel _treatmentsViewmodel;

  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  late List<Widget> _fragments;

  var _isVisibleExperimentButton; // ignore: prefer_typing_uninitialized_variables
  var _isVisibleTreatmentButton; // ignore: prefer_typing_uninitialized_variables
  var _isVisibleEnzymeButton; // ignore: prefer_typing_uninitialized_variables

  @override
  void initState() {
    super.initState();
    _homeViewmodel = GetIt.I.get<HomeViewmodel>();
    _accountViewmodel = GetIt.I.get<AccountViewmodel>();
    _enzymesViewmodel = GetIt.I.get<EnzymesViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();
    _treatmentsViewmodel = GetIt.I.get<TreatmentsViewmodel>();

    if (mounted) {
      setAllButtonsVisible();
      initFragements();

      _homeViewmodel.addListener(
        () {
          if (_homeViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_homeViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );

      _experimentsViewmodel.scrollController.addListener(() {
        if (_experimentsViewmodel
                .scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleExperimentButton == true && mounted) {
            setState(() {
              _isVisibleExperimentButton = false;
            });
          }
        }
        if (_experimentsViewmodel
                .scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleExperimentButton == false && mounted) {
            setState(() {
              _isVisibleExperimentButton = true;
            });
          }
        }
      });

      _treatmentsViewmodel.scrollController.addListener(() {
        if (_treatmentsViewmodel
                .scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleTreatmentButton == true && mounted) {
            setState(() {
              _isVisibleTreatmentButton = false;
            });
          }
        }
        if (_treatmentsViewmodel
                .scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleTreatmentButton == false && mounted) {
            setState(() {
              _isVisibleTreatmentButton = true;
            });
          }
        }
      });

      _enzymesViewmodel.scrollController.addListener(() {
        if (_enzymesViewmodel.scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleEnzymeButton == true && mounted) {
            setState(() {
              _isVisibleEnzymeButton = false;
            });
          }
        }
        if (_enzymesViewmodel.scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleEnzymeButton == false && mounted) {
            setState(() {
              _isVisibleEnzymeButton = true;
            });
          }
        }
      });
    }
  }

  setAllButtonsVisible() {
    if (mounted) {
      setState(() {
        _isVisibleExperimentButton = true;
        _isVisibleTreatmentButton = true;
        _isVisibleEnzymeButton = true;
      });
    }
  }

  initFragements() {
    _fragments = const [
      ExperimentsPage(),
      TreatmentsPage(),
      EnzymesPage(),
      AccountPage(),
    ];
  }

  Widget? get dealWithFloatingActionButton {
    if (_homeViewmodel.fragmentIndex == 0 && _isVisibleExperimentButton) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routing.createExperiment,
          );
        },
        label: Text(
          "Cadastrar\nexperimento",
          style: TextStyles.buttonBackground,
        ),
        icon: const Icon(
          PhosphorIcons.pencilLine,
          color: AppColors.white,
          size: 30,
        ),
      );
    }

    if (_homeViewmodel.fragmentIndex == 1 && _isVisibleTreatmentButton) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routing.createTreatment,
          );
        },
        label: Text(
          "Cadastrar\ntratamento",
          style: TextStyles.buttonBackground,
        ),
        icon: const Icon(
          PhosphorIcons.pencilLine,
          color: AppColors.white,
          size: 30,
        ),
      );
    }

    if (_accountViewmodel.user != null) {
      if (_homeViewmodel.fragmentIndex == 2 &&
          _accountViewmodel.user!.userType == UserTypeEnum.admin &&
          _isVisibleEnzymeButton) {
        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routing.createEnzyme,
            );
          },
          label: Text(
            "Cadastrar\nenzima",
            style: TextStyles.buttonBackground,
          ),
          icon: const Icon(
            PhosphorIcons.pencilLine,
            color: AppColors.white,
            size: 30,
          ),
        );
      }

      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AppSvgs.logo,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
      body: AnimatedBuilder(
        animation: _homeViewmodel,
        builder: (context, child) {
          if (_homeViewmodel.state == StateEnum.loading) {
            return Center(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: animationController.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: SvgPicture.asset(
                  AppSvgs.iconLogo,
                  alignment: Alignment.center,
                  width: 75,
                ),
              ),
            );
          }

          return _fragments[_homeViewmodel.fragmentIndex];
        },
      ),
      floatingActionButton: dealWithFloatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.flask),
            label: 'Experimentos',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.testTube),
            label: 'Tratamentos',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.atom),
            label: 'Enzimas',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.userCircleGear),
            label: 'Conta',
            backgroundColor: AppColors.primary,
          ),
        ],
        currentIndex: _homeViewmodel.fragmentIndex,
        selectedItemColor: AppColors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: AppColors.primary,
        onTap: (index) {
          setAllButtonsVisible();
          int beforeSet = _homeViewmodel.fragmentIndex;
          _homeViewmodel.setFragmentIndex(index);
          if (index == 0 &&
              beforeSet == 0 &&
              _experimentsViewmodel.scrollController.hasClients) {
            _experimentsViewmodel.scrollController.animateTo(
              _experimentsViewmodel.scrollController.position.minScrollExtent +
                  (kBottomNavigationBarHeight / 10000),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
            );
          } else if (index == 1 &&
              beforeSet == 1 &&
              _treatmentsViewmodel.scrollController.hasClients) {
            _treatmentsViewmodel.scrollController.animateTo(
              _treatmentsViewmodel.scrollController.position.minScrollExtent +
                  (kBottomNavigationBarHeight / 10000),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
            );
          } else if (index == 2 &&
              beforeSet == 2 &&
              _enzymesViewmodel.scrollController.hasClients) {
            _enzymesViewmodel.scrollController.animateTo(
              _enzymesViewmodel.scrollController.position.minScrollExtent +
                  (kBottomNavigationBarHeight / 10000),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
            );
          }
        },
      ),
    );
  }
}
