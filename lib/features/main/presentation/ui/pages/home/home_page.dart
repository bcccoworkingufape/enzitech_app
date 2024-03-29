// ignore_for_file: prefer_typing_uninitialized_variables

// 🎯 Dart imports:
import 'dart:async';
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/connection_checker/connection_checker.dart';
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/extensions/extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/ui/widgets/ezt_appbar.dart';
import '../../../../../enzyme/presentation/ui/pages/enzymes_fragment/enzymes_page.dart';
import '../../../../../enzyme/presentation/viewmodel/enzymes_viewmodel.dart';
import '../../../../../experiment/presentation/ui/pages/experiments_fragment/experiments_page.dart';
import '../../../../../experiment/presentation/viewmodel/experiments_viewmodel.dart';
import '../../../../../treatment/presentation/ui/pages/treatments_fragment/treatments_page.dart';
import '../../../../../treatment/presentation/viewmodel/treatments_viewmodel.dart';
import '../../../viewmodel/home_viewmodel.dart';
import '../../../viewmodel/settings_viewmodel.dart';
import '../settings_fragment/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _scaffold = GlobalKey();
  late final HomeViewmodel _homeViewmodel;
  late final SettingsViewmodel _accountViewmodel;
  late final EnzymesViewmodel _enzymesViewmodel;
  late final ExperimentsViewmodel _experimentsViewmodel;
  late final TreatmentsViewmodel _treatmentsViewmodel;
  late final ConnectionChecker _connectionChecker;

  late final AnimationController animationControllerLogo = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  late List<Widget> _fragments;

  var _isVisibleExperimentButton;
  var _isVisibleTreatmentButton;
  var _isVisibleEnzymeButton;

  late StreamSubscription _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _homeViewmodel = GetIt.I.get<HomeViewmodel>();
    _accountViewmodel = GetIt.I.get<SettingsViewmodel>();
    _enzymesViewmodel = GetIt.I.get<EnzymesViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();
    _treatmentsViewmodel = GetIt.I.get<TreatmentsViewmodel>();
    _connectionChecker = GetIt.I.get<ConnectionChecker>();

    _connectionChecker.initialize();

    //! Listen for connection change
    _connectivitySubscription =
        _connectionChecker.connectionChange.listen((event) {
      _homeViewmodel.setHasInternetConnection(event);

      if (!_homeViewmodel.hasInternetConnection) {
        EZTSnackBar.clear(context);
        noInternet(context);
      } else {
        if (_homeViewmodel.notifyInternetConnection) {
          EZTSnackBar.clear(context);
          EZTSnackBar.show(
            context,
            "✓ Conexão reestabelecida",
            centerTitle: true,
            eztSnackBarType: EZTSnackBarType.success,
          );
        }
      }
    });

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
            ).whenComplete(() async {
              if (_homeViewmodel.failure is ExpiredTokenOrWrongUserFailure ||
                  _homeViewmodel.failure is UserNotFoundOrWrongTokenFailure ||
                  _homeViewmodel.failure is SessionNotFoundFailure) {
                debugPrint("SAIR :)");
                _accountViewmodel.logout();

                if (_accountViewmodel.state == StateEnum.success && mounted) {
                  EZTSnackBar.show(
                    context,
                    "Faça seu login novamente.",
                  );
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, Routing.login);
                    _homeViewmodel.setFragmentIndex(0);
                  }
                }
              }
            });
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

  @override
  dispose() {
    _connectivitySubscription.cancel();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        animationControllerLogo.dispose();
      }
    });
    super.dispose();
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
      SettingsPage(),
    ];
  }

  _floatingActionButton(String text, void Function()? onPressed) =>
      FloatingActionButton.extended(
        backgroundColor: context.getApplyedColorScheme.secondaryContainer,
        onPressed: onPressed,
        label: Text(
          text,
          style: TextStyles(context).captionBody(),
        ),
        icon: Icon(
          PhosphorIcons.pencilLine(),
          color: context.getApplyedColorScheme.onSecondaryContainer,
        ),
      );

  Widget? get dealWithFloatingActionButton {
    if (_homeViewmodel.fragmentIndex == 0 && _isVisibleExperimentButton) {
      return _floatingActionButton(
        "Cadastrar\nexperimento",
        () {
          Navigator.pushNamed(
            context,
            Routing.createExperiment,
          );
        },
      );
    }

    if (_homeViewmodel.fragmentIndex == 1 && _isVisibleTreatmentButton) {
      return _floatingActionButton(
        "Cadastrar\ntratamento",
        () {
          Navigator.pushNamed(
            context,
            Routing.createTreatment,
          );
        },
      );
    }

    if (_accountViewmodel.user != null) {
      if (_homeViewmodel.fragmentIndex == 2 &&
          _accountViewmodel.user!.userType == UserTypeEnum.admin &&
          _isVisibleEnzymeButton) {
        return _floatingActionButton(
          "Cadastrar\nenzima",
          () {
            Navigator.pushNamed(
              context,
              Routing.createEnzyme,
            );
          },
        );
      }

      return null;
    }
    return null;
  }

  static noInternet(context) {
    return EZTSnackBar.show(
      context,
      "⚠ Sem conexão com o servidor: Você está visualizando informações previamente carregadas e sem atualizações, quaisquer mudanças offline não serão mantidas!",
      eztSnackBarType: EZTSnackBarType.error,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _homeViewmodel,
      builder: (context, child) {
        return Scaffold(
          key: _scaffold,
          appBar: EZTAppBar(homeViewmodel: _homeViewmodel),
          body: ListenableBuilder(
            listenable: _homeViewmodel,
            builder: (context, child) {
              if (_homeViewmodel.state == StateEnum.loading) {
                return Center(
                  child: ListenableBuilder(
                    listenable: animationControllerLogo,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: animationControllerLogo.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: SvgPicture.asset(
                      AppSvgs(context).iconLogo(),
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
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) {
              setAllButtonsVisible();
              int beforeSet = _homeViewmodel.fragmentIndex;
              _homeViewmodel.setFragmentIndex(index);
              if (index == 0 &&
                  beforeSet == 0 &&
                  _experimentsViewmodel.scrollController.hasClients) {
                _experimentsViewmodel.scrollController.animateTo(
                  _experimentsViewmodel
                          .scrollController.position.minScrollExtent +
                      (kBottomNavigationBarHeight / 10000),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastOutSlowIn,
                );
              } else if (index == 1 &&
                  beforeSet == 1 &&
                  _treatmentsViewmodel.scrollController.hasClients) {
                _treatmentsViewmodel.scrollController.animateTo(
                  _treatmentsViewmodel
                          .scrollController.position.minScrollExtent +
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
            selectedIndex: _homeViewmodel.fragmentIndex,
            destinations: [
              NavigationDestination(
                icon: Icon(PhosphorIcons.flask()),
                label: 'Experimentos',
              ),
              NavigationDestination(
                icon: Icon(PhosphorIcons.testTube()),
                label: 'Tratamentos',
              ),
              NavigationDestination(
                icon: Icon(PhosphorIcons.atom()),
                label: 'Enzimas',
              ),
              NavigationDestination(
                icon: Icon(PhosphorIcons.gear()),
                label: 'Configurações',
              ),
            ],
          ),
        );
      },
    );
  }
}
